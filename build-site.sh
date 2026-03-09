#!/usr/bin/env bash
set -euo pipefail

# Build a static HTML site from the markdown files in this repo.
# Output goes to _site/. Optionally push to gh-pages branch for GitHub Pages.
#
# Usage:
#   ./build-site.sh          # build only
#   ./build-site.sh --push   # build and push to gh-pages

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO_ROOT"
SITE_DIR="$REPO_ROOT/_site"
PUSH=false

for arg in "$@"; do
  case "$arg" in
    --push) PUSH=true ;;
  esac
done

# Install marked if needed
if [ ! -d "$REPO_ROOT/node_modules/marked" ]; then
  echo "Installing marked..."
  npm install --no-save marked
fi

# Clean and create output dir
rm -rf "$SITE_DIR"
mkdir -p "$SITE_DIR"

# Pages to include (order matters for nav)
PAGES=(README beginner intermediate advanced CONTRIBUTING)

# Convert markdown to HTML using node + marked
convert_md() {
  local md_file="$1"
  local html_file="$2"
  local title

  title=$(head -1 "$md_file" | sed 's/^#\+ *//' | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')

  node -e "
    const fs = require('fs');
    const { marked } = require('marked');

    let md = fs.readFileSync(process.argv[1], 'utf8');

    // Rewrite .md links to .html (but not external URLs)
    md = md.replace(/\]\(([^)#]+)\.md(#[^)]*)?\)/g, (match, p1, hash) => {
      if (p1.startsWith('http')) return match;
      // README.md -> index.html
      const name = p1 === 'README' ? 'index' : p1;
      return '](' + name + '.html' + (hash || '') + ')';
    });

    const html = marked.parse(md);
    process.stdout.write(html);
  " "$md_file" > "$html_file.body"

  # Build the full HTML page
  # Write title line separately (avoids shell expansion issues in heredoc)
  printf '<!DOCTYPE html>\n<html lang="en">\n<head>\n  <meta charset="utf-8">\n  <meta name="viewport" content="width=device-width, initial-scale=1">\n  <title>%s</title>\n' "$title" > "$html_file"

  cat >> "$html_file" <<'HTMLEOF'
  <style>
    :root {
      --bg: #ffffff;
      --fg: #1a1a1a;
      --accent: #2563eb;
      --muted: #6b7280;
      --border: #e5e7eb;
      --code-bg: #f3f4f6;
      --nav-bg: #f9fafb;
    }
    @media (prefers-color-scheme: dark) {
      :root {
        --bg: #111827;
        --fg: #f3f4f6;
        --accent: #60a5fa;
        --muted: #9ca3af;
        --border: #374151;
        --code-bg: #1f2937;
        --nav-bg: #1a2332;
      }
    }
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      background: var(--bg);
      color: var(--fg);
      line-height: 1.7;
    }
    nav {
      background: var(--nav-bg);
      border-bottom: 1px solid var(--border);
      padding: 0.75rem 1.5rem;
      display: flex;
      gap: 1.5rem;
      flex-wrap: wrap;
      align-items: center;
    }
    nav a {
      color: var(--accent);
      text-decoration: none;
      font-size: 0.9rem;
      font-weight: 500;
    }
    nav a:hover { text-decoration: underline; }
    nav .brand {
      font-weight: 700;
      font-size: 1rem;
      color: var(--fg);
      margin-right: auto;
    }
    main {
      max-width: 48rem;
      margin: 2rem auto;
      padding: 0 1.5rem;
    }
    h1 { font-size: 2rem; margin: 1.5rem 0 1rem; }
    h2 { font-size: 1.5rem; margin: 2rem 0 0.75rem; border-bottom: 1px solid var(--border); padding-bottom: 0.3rem; }
    h3 { font-size: 1.17rem; margin: 1.5rem 0 0.5rem; }
    p { margin: 0.75rem 0; }
    a { color: var(--accent); }
    ul, ol { margin: 0.75rem 0; padding-left: 1.5rem; }
    li { margin: 0.25rem 0; }
    code {
      background: var(--code-bg);
      padding: 0.15rem 0.35rem;
      border-radius: 3px;
      font-size: 0.9em;
    }
    pre {
      background: var(--code-bg);
      padding: 1rem;
      border-radius: 6px;
      overflow-x: auto;
      margin: 1rem 0;
    }
    pre code { background: none; padding: 0; }
    blockquote {
      border-left: 3px solid var(--accent);
      padding: 0.5rem 1rem;
      margin: 1rem 0;
      color: var(--muted);
    }
    table { border-collapse: collapse; margin: 1rem 0; width: 100%; }
    th, td { border: 1px solid var(--border); padding: 0.5rem 0.75rem; text-align: left; }
    th { background: var(--code-bg); }
    strong { font-weight: 600; }
    hr { border: none; border-top: 1px solid var(--border); margin: 2rem 0; }
  </style>
</head>
<body>
  <nav>
    <span class="brand">RPI with Coding Agents</span>
    <a href="index.html">Home</a>
    <a href="beginner.html">Beginner</a>
    <a href="intermediate.html">Intermediate</a>
    <a href="advanced.html">Advanced</a>
    <a href="CONTRIBUTING.html">Contributing</a>
  </nav>
  <main>
HTMLEOF

  cat "$html_file.body" >> "$html_file"

  cat >> "$html_file" <<'HTMLEOF'
  </main>
</body>
</html>
HTMLEOF

  rm "$html_file.body"
}

# Build each page
for page in "${PAGES[@]}"; do
  md_file="$REPO_ROOT/${page}.md"
  if [ "$page" = "README" ]; then
    html_file="$SITE_DIR/index.html"
  else
    html_file="$SITE_DIR/${page}.html"
  fi
  echo "Building: ${page}.md -> $(basename "$html_file")"
  convert_md "$md_file" "$html_file"
done

echo "Site built in $SITE_DIR/"

# Push to gh-pages if requested
if [ "$PUSH" = true ]; then
  echo "This will force-push to the gh-pages branch."
  read -rp "Continue? [y/N] " confirm
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
  fi

  echo "Deploying to gh-pages..."
  ORIGIN_URL="$(git -C "$REPO_ROOT" remote get-url origin)"
  COMMIT_MSG="Deploy site from $(git -C "$REPO_ROOT" rev-parse --short HEAD)"

  DEPLOY_DIR=$(mktemp -d)
  trap 'rm -rf "$DEPLOY_DIR"' EXIT

  cp -r "$SITE_DIR"/. "$DEPLOY_DIR"/
  touch "$DEPLOY_DIR/.nojekyll"
  cd "$DEPLOY_DIR"

  git init
  git checkout -b gh-pages
  git add -A
  git commit -m "$COMMIT_MSG"
  git remote add origin "$ORIGIN_URL"
  git push origin gh-pages --force

  cd "$REPO_ROOT"
  echo "Deployed to gh-pages."
fi
