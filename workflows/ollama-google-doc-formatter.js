// n8n Code node: "Format Proposal for Google Docs"
// Google Docs ignores most <style> blocks — use tables + inline styles only.
const agentOut = $('AI Agent').first().json.output || '';
const router = $('Scenario Router').first().json;
const scenarioLabel = router.scenarioLabel || 'Proposal';
const scenarioName = router.scenarioName || 'OpenShift Solution Architect';
const rawUser = String(router.chatInput || '').split('---')[0].trim();

let customer = 'Customer';
const nameMatch =
  rawUser.match(/(?:notes|request|analysis)\s*[-–]\s*([^\n(]+)/i) ||
  rawUser.match(/^([A-Z][A-Za-z0-9 &.'-]{2,40})(?:\s+\(|$)/m);
if (nameMatch) customer = nameMatch[1].trim().replace(/\s+/g, ' ');

const generatedAt = new Date().toISOString().slice(0, 16).replace('T', ' ');

const RH_RED = '#EE0000';
const RH_DARK = '#1A1A1A';
const TEXT_DARK = '#212121';
const TEXT_MUTED = '#444444';
const BORDER = '#CCCCCC';

function escapeHtml(s) {
  return String(s)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

function inlineMarkdown(line) {
  let s = escapeHtml(line);
  s = s.replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>');
  s = s.replace(/\*(.+?)\*/g, '<em>$1</em>');
  s = s.replace(/`([^`]+)`/g, `<span style="font-family:Consolas,monospace;background-color:#F5F5F5;padding:1px 4px;">$1</span>`);
  return s;
}

function sectionHeading(title) {
  return (
    `<table border="0" cellpadding="0" cellspacing="0" width="100%" style="width:100%;margin:20px 0 6px 0;">` +
    `<tr><td style="border-bottom:2px solid ${RH_RED};padding-bottom:4px;">` +
    `<span style="font-family:Arial,Helvetica,sans-serif;font-size:14pt;font-weight:bold;color:${RH_RED};">${escapeHtml(title)}</span>` +
    `</td></tr></table>`
  );
}

function bodyParagraph(text) {
  return (
    `<p style="font-family:Arial,Helvetica,sans-serif;font-size:11pt;color:${TEXT_DARK};line-height:1.5;margin:0 0 10px 0;text-align:left;">` +
    `${inlineMarkdown(text)}</p>`
  );
}

function markdownToHtml(md) {
  const lines = md.replace(/\r\n/g, '\n').split('\n');
  const out = [];
  let inCode = false;
  let codeBuf = [];
  let tableRows = [];
  let listType = null;

  function flushTable() {
    if (!tableRows.length) return;
    const rows = tableRows.filter((r) => r.some((c) => c.trim()));
    if (!rows.length) {
      tableRows = [];
      return;
    }
    const header = rows[0];
    const body = rows.slice(1).filter((r) => !r.every((c) => /^-+$/.test(c.trim())));
    out.push(
      `<table border="1" cellpadding="8" cellspacing="0" width="100%" style="width:100%;border-collapse:collapse;margin:12px 0;">`,
    );
    out.push('<tr>');
    for (const c of header) {
      out.push(
        `<td bgcolor="${RH_RED}" style="background-color:${RH_RED};color:#FFFFFF;font-family:Arial,sans-serif;font-size:10pt;font-weight:bold;border:1px solid ${BORDER};">${inlineMarkdown(c.trim())}</td>`,
      );
    }
    out.push('</tr>');
    let even = false;
    for (const row of body) {
      even = !even;
      const bg = even ? '#FAFAFA' : '#FFFFFF';
      out.push('<tr>');
      for (const c of row) {
        out.push(
          `<td bgcolor="${bg}" style="background-color:${bg};color:${TEXT_DARK};font-family:Arial,sans-serif;font-size:10pt;border:1px solid ${BORDER};vertical-align:top;">${inlineMarkdown(c.trim())}</td>`,
        );
      }
      out.push('</tr>');
    }
    out.push('</table>');
    tableRows = [];
  }

  function closeList() {
    if (listType) {
      out.push(listType === 'ul' ? '</ul>' : '</ol>');
      listType = null;
    }
  }

  const listStyle =
    'font-family:Arial,Helvetica,sans-serif;font-size:11pt;color:' + TEXT_DARK + ';margin:0 0 10px 18px;';

  for (const line of lines) {
    if (line.trim().startsWith('```')) {
      if (inCode) {
        out.push(
          `<p style="font-family:Consolas,monospace;font-size:9.5pt;background-color:#F5F5F5;border-left:4px solid ${RH_RED};padding:10px 12px;color:${TEXT_DARK};margin:10px 0;">` +
            escapeHtml(codeBuf.join('\n')) +
            '</p>',
        );
        codeBuf = [];
        inCode = false;
      } else {
        flushTable();
        closeList();
        inCode = true;
      }
      continue;
    }
    if (inCode) {
      codeBuf.push(line);
      continue;
    }

    if (line.includes('|') && /^\s*\|?.+\|.+/.test(line)) {
      closeList();
      const cells = line
        .trim()
        .replace(/^\|/, '')
        .replace(/\|$/, '')
        .split('|')
        .map((c) => c.trim());
      tableRows.push(cells);
      continue;
    }
    flushTable();

    const h1 = line.match(/^#\s+(.+)/);
    const h2 = line.match(/^##\s+(.+)/);
    const h3 = line.match(/^###\s+(.+)/);
    if (h1) {
      closeList();
      out.push(sectionHeading(h1[1]));
      continue;
    }
    if (h2) {
      closeList();
      out.push(sectionHeading(h2[1]));
      continue;
    }
    if (h3) {
      closeList();
      out.push(
        `<p style="font-family:Arial,sans-serif;font-size:12pt;font-weight:bold;color:${TEXT_DARK};margin:14px 0 6px 0;">${inlineMarkdown(h3[1])}</p>`,
      );
      continue;
    }

    const ul = line.match(/^\s*[-*]\s+(.+)/);
    const ol = line.match(/^\s*\d+\.\s+(.+)/);
    if (ul) {
      if (listType !== 'ul') {
        closeList();
        listType = 'ul';
        out.push(`<ul style="${listStyle}">`);
      }
      out.push(`<li style="margin:4px 0;">${inlineMarkdown(ul[1])}</li>`);
      continue;
    }
    if (ol) {
      if (listType !== 'ol') {
        closeList();
        listType = 'ol';
        out.push(`<ol style="${listStyle}">`);
      }
      out.push(`<li style="margin:4px 0;">${inlineMarkdown(ol[1])}</li>`);
      continue;
    }

    closeList();
    if (!line.trim()) continue;
    out.push(bodyParagraph(line));
  }

  flushTable();
  closeList();
  if (inCode && codeBuf.length) {
    out.push(
      `<p style="font-family:Consolas,monospace;font-size:9.5pt;background-color:#F5F5F5;border-left:4px solid ${RH_RED};padding:10px 12px;color:${TEXT_DARK};">${escapeHtml(codeBuf.join('\n'))}</p>`,
    );
  }
  return out.join('\n');
}

const bodyHtml = markdownToHtml(agentOut);

// Cover: single full-width table — bgcolor + inline color (survives Google Docs import)
const coverHtml = `
<table border="0" cellpadding="0" cellspacing="0" width="100%" style="width:100%;border-collapse:collapse;margin:0 0 24px 0;">
  <tr>
    <td bgcolor="${RH_RED}" style="background-color:${RH_RED};padding:10px 16px;">
      <span style="font-family:Arial,Helvetica,sans-serif;font-size:10pt;font-weight:bold;color:#FFFFFF;letter-spacing:1px;">RED HAT OPENSHIFT</span>
    </td>
  </tr>
  <tr>
    <td bgcolor="${RH_DARK}" style="background-color:${RH_DARK};padding:28px 16px 8px 16px;">
      <span style="font-family:Arial,Helvetica,sans-serif;font-size:22pt;font-weight:bold;color:#FFFFFF;display:block;margin-bottom:6px;">${escapeHtml(customer)}</span>
      <span style="font-family:Arial,Helvetica,sans-serif;font-size:14pt;color:#FFCCCC;display:block;margin-bottom:16px;">${escapeHtml(scenarioLabel)}</span>
    </td>
  </tr>
  <tr>
    <td bgcolor="#F5F5F5" style="background-color:#F5F5F5;padding:12px 16px 16px 16px;border-bottom:3px solid ${RH_RED};">
      <span style="font-family:Arial,Helvetica,sans-serif;font-size:10pt;color:${TEXT_DARK};line-height:1.6;">
        <strong>Document type:</strong> ${escapeHtml(scenarioName)}<br>
        <strong>Generated:</strong> ${escapeHtml(generatedAt)} UTC<br>
        <strong>Classification:</strong> Customer confidential — draft for internal review
      </span>
    </td>
  </tr>
</table>`;

const footerHtml = `
<table border="0" cellpadding="0" cellspacing="0" width="100%" style="width:100%;margin-top:28px;">
  <tr>
    <td style="border-top:1px solid ${BORDER};padding-top:10px;">
      <span style="font-family:Arial,sans-serif;font-size:9pt;color:#666666;">
        Generated by OpenShift Solution Architect (Ollama). Cost figures are approximate unless cited from live cluster data (MCP).
      </span>
    </td>
  </tr>
</table>`;

const html = `<!DOCTYPE html>
<html><head><meta charset="utf-8"></head>
<body style="font-family:Arial,Helvetica,sans-serif;font-size:11pt;color:${TEXT_DARK};margin:0;padding:0;">
${coverHtml}
${bodyHtml}
${footerHtml}
</body></html>`;

const docTitle = `OpenShift ${scenarioLabel} — ${customer} — ${generatedAt.slice(0, 10)}`;
const folderId = 'REPLACE_WITH_GOOGLE_DRIVE_FOLDER_ID';

const boundary = 'n8n_boundary_' + Date.now();
const meta = {
  name: docTitle,
  mimeType: 'application/vnd.google-apps.document',
};
if (folderId && !String(folderId).startsWith('REPLACE')) {
  meta.parents = [folderId];
}
const metadata = JSON.stringify(meta);
const multipartBody =
  `--${boundary}\r\n` +
  `Content-Type: application/json; charset=UTF-8\r\n\r\n` +
  `${metadata}\r\n` +
  `--${boundary}\r\n` +
  `Content-Type: text/html; charset=UTF-8\r\n\r\n` +
  `${html}\r\n` +
  `--${boundary}--\r\n`;

const contentType = `multipart/related; boundary=${boundary}`;

return {
  json: {
    docTitle,
    boundary,
    contentType,
    multipartBody,
    folderId: folderId && !String(folderId).startsWith('REPLACE') ? folderId : '',
    customer,
    scenarioLabel,
    webViewLinkHint: 'See Upload styled Google Doc → webViewLink',
  },
};
