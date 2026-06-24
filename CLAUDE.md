# Alex Cain Portfolio — Design System

All pages in this project must follow these rules. When building new sections or pages, use the CSS variables defined in `:root` and match the patterns below.

## Colours

All defined as CSS variables. Never hardcode these values.

| Token | Value | Use |
|---|---|---|
| `--blue` | `#3737f5` | Primary background (nav, hero, colleagues) |
| `--orange` | `#eb5127` | Headings, accents, CTAs |
| `--cream` | `#fcfaf0` | Page background |
| `--brown` | `#7a6045` | Body text, muted labels |
| `--dark` | `#1c1208` | Footer, submit buttons |
| `--border` | `#e5d5be` | Dividers, form borders |
| `--white` | `#ffffff` | Text on dark backgrounds |

## Typography

Use CSS variable values. Never freehand a font size.

| Token | Value | Use |
|---|---|---|
| `--text-hero` | `clamp(56px, 9.8vw, 158px)` | PRODUCT / DESIGNER hero words |
| `--text-heading` | `clamp(36px, 3.9vw, 50px)` | Section labels (CASE STUDIES, WHAT COLLEAGUES SAY) |
| `--text-title` | `36px` | Project titles, card roles |
| `--text-body` | `18px` | All body copy, always `line-height: 28px` |
| `--text-label` | `14px` | Names, meta, small UI text |
| `--text-cta` | `14px` | Uppercase CTAs and links, `letter-spacing: 1.24px` |

Fonts in use (two families only — do not introduce a third):
- **Barlow Condensed 900** — hero words and all section headings (`text-transform: uppercase`)
- **Barlow 400/500/600** — everything else: body copy, titles, nav, CTAs, buttons, footer

Button/submit text: Barlow 600, 18px (per Refactoring UI recommendation of 18–20px for buttons).
Nav CTA pill: Barlow 500, 16px. Footer and small labels: Barlow 400, 13–14px.

## Spacing

All main sections use CSS variables. New sections must follow this pattern.

| Token | Value | Use |
|---|---|---|
| `--pad-section-v` | `56px` | Top/bottom padding on every section |
| `--pad-section-h` | `48px` | Left/right at base (< 768px) |
| `--pad-section-h-md` | `4rem` | Left/right at 768px+ |
| `--pad-section-h-lg` | `8rem` | Left/right at 1024px+ |

Section padding pattern (copy this for every new section):
```css
.my-section { padding: var(--pad-section-v) var(--pad-section-h); }

@media (min-width: 768px) {
  .my-section { padding-left: var(--pad-section-h-md); padding-right: var(--pad-section-h-md); }
}
@media (min-width: 1024px) {
  .my-section { padding-left: var(--pad-section-h-lg); padding-right: var(--pad-section-h-lg); }
}
```

Mobile overrides (< 900px) drop vertical padding to ~40px and horizontal to 24px.

## Radii

| Token | Value | Use |
|---|---|---|
| `--radius-card` | `16px` | Cards (flip cards, project thumbs) |
| `--radius-pill` | `100px` | Buttons, nav status badge |
| `--radius-input` | `10px` | Form fields, submit button |

## Section structure

Each page section follows this HTML pattern:

```html
<section class="my-section">
  <h2 class="section-heading">Section Title</h2>
  <!-- content -->
</section>
```

The `.section-heading` class handles typography (Barlow Condensed 900, orange, uppercase). Reuse it everywhere.

## Border and dividers

Sections on the cream background are separated by `1px solid var(--border)`. Blue sections (hero, colleagues) butt up against each other with no border.

## Navigation

The nav is a floating pill: `position: fixed; top: 20px;` with `height: 56px`, so its bottom edge sits at **76px** from the viewport top.

The first content element on every page (hero title, page title, etc.) must have **72px of clearance below the nav bottom**, meaning `padding-top: 148px` on its section. The nav CTA is always labelled **"Contact"**. Nav links use the same labels on every page: About · My Projects · My Thoughts · CV.

## Responsive breakpoints

| Breakpoint | Target |
|---|---|
| `max-width: 600px` | Small mobile |
| `max-width: 900px` | Mobile (stacks columns, hamburger nav) |
| `min-width: 768px` | Tablet (wider horizontal padding) |
| `min-width: 1024px` | Desktop (max horizontal padding, multi-column layouts) |
| `min-width: 1280px` | Wide desktop (iphone zoom scale) |
