# Contributing and maintaining the docs

Use a branch for a focused change and describe the resulting behavior, why it matters, and how you checked it. For application changes, identify the service and environment involved. Include relevant diagnostics, but remove access tokens, credentials, and personal data from shared logs.

Treat other contributors respectfully. Harassment, personal attacks, and discriminatory behavior are not acceptable. Contributions to this repository are covered by its MIT license.

## Preview locally

Use Python 3.11 or newer. From the repository root:

```bash
python3 -m venv .venv-docs
source .venv-docs/bin/activate
python -m pip install -r requirements-docs.txt
zensical serve
```

Open <http://localhost:8000>. Source changes under `docs/` are reflected in the preview. Use Ctrl+C to stop it. With uv, the equivalent environment setup is `uv venv .venv-docs` followed by `uv pip install --python .venv-docs/bin/python -r requirements-docs.txt`; activate that environment before running Zensical.

The generator version is pinned in `requirements-docs.txt`. Node.js, Next.js, MDX, and Fumadocs are no longer part of the documentation toolchain. See [Zensical's installation guide](https://zensical.org/docs/get-started/) for platform-specific setup.

## Write a page

Write ordinary Markdown under `docs/` and add the page to `nav` in `zensical.toml`. Use relative Markdown links between pages, descriptive link text, and fenced code blocks with a language. Mermaid diagrams are supported for small architecture or sequence explanations.

Choose the page's purpose before writing:

| Type | Reader's question | Include |
| --- | --- | --- |
| Tutorial | How do I achieve my first result? | Starting state, ordered steps, visible checkpoints |
| Concept | Why does this work this way? | A small project-specific example and its tradeoffs |
| Guide | How do I complete this task? | Preconditions, commands, verification |
| Reference | What exact interface or value exists? | Names, types, defaults, source locations |

Explain examples using the checked-in project, and link to upstream documentation for the broader tool. Separate implemented behavior from proposed changes. If a configuration is incomplete, say where and how to investigate it. Do not invent test coverage or claim a deployment was verified when only the documentation was built.

## Build and check

```bash
zensical build --strict
```

The static output goes to ignored `site/`. Inspect changed pages, navigation, code blocks, tables, diagrams, and mobile layout in the preview. Check internal links and anchors as well as the build result; validation capabilities depend on the pinned generator version. The GitLab `docs-build` job installs the same requirement, performs a strict build, and saves `site/` as an artifact.

When updating the generator, change the pin deliberately, rebuild, and review the rendered result. Keep `.venv-docs/`, `.cache/`, and `site/` out of commits.

## Serve a static build

For a local check of the generated files:

```bash
python -m http.server 8000 --directory site
```

For hosting, copy the **contents of `site/`** to a static web server's document root. For example, an Nginx location serving this site at the domain root can use:

```nginx
server {
    listen 80;
    server_name docs.example.com;
    root /srv/www/purchase-system-docs;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

Replace the example hostname and directory with your deployment values. This configuration illustrates static file serving; DNS and HTTPS belong to the chosen host. If serving from a subpath, configure the final `site_url` in `zensical.toml` and verify links at that base path. See [Zensical's build documentation](https://zensical.org/docs/usage/build/).

This migration configures builds and local previews; it does not publish the site or push tags. The local `pre-zensical` tag preserves the committed baseline described in [project history](project-history.md).
