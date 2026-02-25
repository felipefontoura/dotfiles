Act as a senior UX/UI designer doing reverse engineering. Extract a comprehensive, production-ready design system from $ARGUMENTS and output everything needed to bootstrap a Next.js + Shadcn + TailwindCSS v4 project.

## Input Detection

Detect the input type and process accordingly:

| Input | How to process |
|-------|---------------|
| Image path (`.png`, `.jpg`, `.webp`) | Read the image directly (multimodal) |
| URL (`https://...` not Figma) | Take screenshot via Playwright (`browser_navigate` → `browser_take_screenshot`), then analyze |
| Figma URL (`figma.com/design/...`) | Use `get_design_context` + `get_screenshot` MCP tools |
| Directory path | Read CSS/Tailwind config, globals.css, component files |
| No argument | Ask what to analyze |

## Extraction Scope

Analyze the source and extract **all 10 dimensions** below. Be specific — use exact hex/oklch values, pixel measurements, and real font names. Do not use placeholders when you can infer actual values.

### 1. Design Principles
- Visual style (minimal, brutalist, playful, corporate, etc.)
- Layout philosophy (dense vs airy, card-based vs list, etc.)
- Interaction patterns (hover effects, focus states, transitions)

### 2. Color System
- **Palette:** primary, secondary, accent, muted, destructive + their foreground variants
- **Neutral scale:** background, foreground, card, popover, border, input, ring
- **Semantic:** success, warning, error, info
- **Dark mode:** inferred inverse palette
- **Contrast:** WCAG AA compliance notes

### 3. Typography
- Font families (heading, body, mono)
- Type scale (xs through 4xl) with size/line-height/weight
- Heading styles (h1-h6 mapping)
- Special text styles (lead, muted, blockquote, code)

### 4. Spacing & Sizing
- Base unit (4px or 8px)
- Spacing scale
- Component sizing (heights for buttons, inputs, avatars)
- Container max-widths

### 5. Borders & Radius
- Border widths and colors
- Radius tokens (none, sm, md, lg, xl, full)
- Divider styles

### 6. Shadows & Elevation
- Shadow scale (sm, md, lg, xl, 2xl)
- Elevation system (flat, raised, floating, overlay)

### 7. Motion & Animation
- Transition duration tokens (fast, normal, slow)
- Easing curves
- Common animations (fade-in, slide-up, scale)

### 8. Layout System
- Grid columns and gaps
- Breakpoints (sm, md, lg, xl, 2xl)
- Container widths per breakpoint
- Common layout patterns (sidebar + content, stacked, dashboard grid)

### 9. Component Inventory
- Every visible component mapped to Shadcn equivalent
- Variant descriptions (size, color, state)
- Custom components not in Shadcn (what to build)
- Component composition patterns

### 10. Iconography & Assets
- Icon style (outline, solid, duotone)
- Icon library suggestion (Lucide, Phosphor, Heroicons)
- Logo/brand treatment notes

---

## Output

Produce **3 parts** in order. Do not skip any part.

---

### Part A — Design System Specification

```
## Design System: {source}

---

### 1. Design Principles
- **Style:** {minimal / corporate / playful / ...}
- **Density:** {compact / comfortable / spacious}
- **Corners:** {sharp / slightly rounded / rounded / pill}
- **Depth:** {flat / subtle shadows / layered elevation}
- **Motion:** {none / subtle / expressive}

---

### 2. Colors

#### Brand Palette
| Token | Light | Dark | Usage |
|-------|-------|------|-------|
| `primary` | #XXXX | #XXXX | CTA buttons, links, focus rings |
| `primary-foreground` | #XXXX | #XXXX | Text on primary |
| `secondary` | #XXXX | #XXXX | Secondary actions |
| `secondary-foreground` | #XXXX | #XXXX | Text on secondary |
| `accent` | #XXXX | #XXXX | Highlights, hover backgrounds |
| `accent-foreground` | #XXXX | #XXXX | Text on accent |

#### Semantic Colors
| Token | Light | Dark | Usage |
|-------|-------|------|-------|
| `destructive` | #XXXX | #XXXX | Errors, delete actions |
| `destructive-foreground` | #XXXX | #XXXX | Text on destructive |
| `success` | #XXXX | #XXXX | Confirmations |
| `warning` | #XXXX | #XXXX | Alerts |
| `info` | #XXXX | #XXXX | Informational |

#### Neutrals
| Token | Light | Dark |
|-------|-------|------|
| `background` | #XXXX | #XXXX |
| `foreground` | #XXXX | #XXXX |
| `card` | #XXXX | #XXXX |
| `card-foreground` | #XXXX | #XXXX |
| `popover` | #XXXX | #XXXX |
| `popover-foreground` | #XXXX | #XXXX |
| `muted` | #XXXX | #XXXX |
| `muted-foreground` | #XXXX | #XXXX |
| `border` | #XXXX | #XXXX |
| `input` | #XXXX | #XXXX |
| `ring` | #XXXX | #XXXX |

---

### 3. Typography

**Fonts:**
| Role | Family | Source |
|------|--------|--------|
| Sans (body) | {name} | Google Fonts / system |
| Heading | {name} | Google Fonts / system |
| Mono | {name} | Google Fonts / system |

**Scale:**
| Token | Size | Line Height | Weight |
|-------|------|-------------|--------|
| `text-xs` | 0.75rem | 1rem | 400 |
| `text-sm` | 0.875rem | 1.25rem | 400 |
| `text-base` | 1rem | 1.5rem | 400 |
| `text-lg` | 1.125rem | 1.75rem | 400 |
| `text-xl` | 1.25rem | 1.75rem | 600 |
| `text-2xl` | 1.5rem | 2rem | 600 |
| `text-3xl` | 1.875rem | 2.25rem | 700 |
| `text-4xl` | 2.25rem | 2.5rem | 700 |

**Headings:**
| Level | Size | Weight | Tracking | Margin |
|-------|------|--------|----------|--------|
| h1 | 2.25rem | 700 | -0.025em | mb-6 |
| h2 | 1.875rem | 600 | -0.025em | mb-4 |
| h3 | 1.5rem | 600 | -0.02em | mb-3 |
| h4 | 1.25rem | 600 | normal | mb-2 |

---

### 4. Spacing
- **Base:** Xpx
- **Scale:** 0, 0.5, 1, 1.5, 2, 2.5, 3, 4, 5, 6, 8, 10, 12, 16, 20, 24, 32, 40, 48, 64

**Component sizes:**
| Element | Height | Padding X | Padding Y |
|---------|--------|-----------|-----------|
| Button sm | 32px | 12px | 6px |
| Button md | 40px | 16px | 8px |
| Button lg | 48px | 24px | 12px |
| Input | 40px | 12px | 8px |
| Avatar sm | 32px | — | — |
| Avatar md | 40px | — | — |
| Avatar lg | 48px | — | — |

---

### 5. Radius
| Token | Value | Used on |
|-------|-------|---------|
| `radius-sm` | Xrem | Badges, tags |
| `radius-md` | Xrem | Buttons, inputs |
| `radius-lg` | Xrem | Cards, dialogs |
| `radius-xl` | Xrem | Large containers |
| `radius-full` | 9999px | Avatars, pills |

---

### 6. Shadows
| Token | Value | Used on |
|-------|-------|---------|
| `shadow-sm` | 0 1px 2px ... | Buttons, inputs |
| `shadow-md` | 0 4px 6px ... | Cards, dropdowns |
| `shadow-lg` | 0 10px 15px ... | Dialogs, popovers |
| `shadow-xl` | 0 20px 25px ... | Modals, toasts |

---

### 7. Motion
| Token | Duration | Easing | Used on |
|-------|----------|--------|---------|
| `fast` | 150ms | ease-out | Hover, focus |
| `normal` | 200ms | ease-in-out | Expand, collapse |
| `slow` | 300ms | ease-in-out | Page transitions |

---

### 8. Layout
- **Breakpoints:** sm:640 md:768 lg:1024 xl:1280 2xl:1536
- **Container:** max-w-7xl centered with px-4 md:px-6 lg:px-8
- **Grid:** 12-column, gap-4 md:gap-6
- **Sidebar width:** 256px (collapsed: 64px)
- **Navbar height:** 64px
- **Common patterns:** {list observed layouts}

---

### 9. Component Inventory

| Component | Shadcn | Variants | Custom notes |
|-----------|--------|----------|-------------|
| Primary button | `Button` default | sm, md, lg | ... |
| Secondary button | `Button` secondary | sm, md, lg | ... |
| Outline button | `Button` outline | sm, md, lg | ... |
| Ghost button | `Button` ghost | sm, md, lg | ... |
| Destructive button | `Button` destructive | sm, md, lg | ... |
| Link button | `Button` link | — | ... |
| Text input | `Input` | default, error, disabled | ... |
| Textarea | `Textarea` | default, error | ... |
| Select | `Select` | — | ... |
| Checkbox | `Checkbox` | — | ... |
| Switch | `Switch` | — | ... |
| Card | `Card` | default, interactive | ... |
| Dialog | `Dialog` | — | ... |
| Sheet (drawer) | `Sheet` | side variants | ... |
| Table | `Table` | striped, hoverable | ... |
| Tabs | `Tabs` | default, pills | ... |
| Badge | `Badge` | default, secondary, outline | ... |
| Avatar | `Avatar` | sm, md, lg | ... |
| Toast | `Sonner` | success, error, info | ... |
| Tooltip | `Tooltip` | — | ... |
| Dropdown menu | `DropdownMenu` | — | ... |
| Navigation menu | `NavigationMenu` | — | ... |
| Breadcrumb | `Breadcrumb` | — | ... |
| Pagination | `Pagination` | — | ... |
| Skeleton | `Skeleton` | — | ... |

**Not in Shadcn (need custom):**
- {component}: {description}

---

### 10. Iconography
- **Style:** {outline / solid / duotone}
- **Library:** {Lucide / Phosphor / Heroicons}
- **Default size:** Xpx (matches text-base line-height)
- **Stroke width:** Xpx
```

Replace all `#XXXX` and `X` placeholders with **actual values** extracted from the source.

---

### Part B — Console Wireframes (Figma on Terminal)

Draw ASCII/Unicode wireframes for every key component. These serve as visual reference without leaving the terminal.

**Rules:**
- Use `─│┌┐└┘├┤┬┴┼` for borders (Unicode box drawing)
- Use `■` for filled/primary elements, `○` for outline variants
- Annotate dimensions (height, padding) on the right side with `← arrows`
- Annotate tokens (colors, fonts, radius) below each component
- Show hover/focus states where relevant
- Group related components with section headers using `────` lines

**Required wireframes:**

1. **Button variants** — default, outline, ghost, destructive at sm/md/lg sizes
2. **Input** — default, error, with label + helper text
3. **Card** — with header, content, footer sections
4. **Navigation bar** — logo, links, actions, mobile menu icon
5. **Sidebar + content layout** — collapsible sidebar with navigation items
6. **Table** — sortable header, rows, actions column
7. **Dialog / Modal** — with overlay, title, content, action buttons
8. **Form layout** — complete form with multiple field types
9. **Toast / Notification** — success, error, info variants
10. **Badge variants** — all color variants with sizing

Example wireframe format:

```
────────────────────────────────────────────────
 BUTTON VARIANTS
────────────────────────────────────────────────

 Default (md)                     Outline (md)
 ┌─────────────────────┐         ┌─────────────────────┐
 │   ■ Get Started     │ 40px    │   ○ Get Started     │ 40px
 └─────────────────────┘         └─────────────────────┘
  bg: primary (#XXXX)             bg: transparent
  text: primary-fg (#XXXX)        text: foreground
  font: text-sm / 500             border: 1px border
  px: 16px  radius: radius-md     hover: bg accent/10
```

Use the **actual extracted values** (colors, sizes, fonts) in annotations, not placeholders.

---

### Part C — Next.js Implementation Code

Output ready-to-paste code blocks for bootstrapping the project. Use the actual extracted values.

#### 1. globals.css

Use TailwindCSS v4 `@theme` syntax with `oklch()` color values. Include:
- All color tokens (brand, semantic, neutrals)
- Font families
- Radius scale
- Shadow scale
- Animation duration tokens
- Shadcn HSL variables in `@layer base` for both `:root` (light) and `.dark`

```css
@import "tailwindcss";

@theme {
  /* Colors — use actual oklch values */
  --color-primary: oklch(...);
  --color-primary-foreground: oklch(...);
  /* ... all tokens ... */

  /* Fonts */
  --font-sans: "{font}", ui-sans-serif, system-ui, sans-serif;
  --font-mono: "{font}", ui-monospace, monospace;

  /* Radius */
  --radius-sm: 0.25rem;
  --radius-md: 0.5rem;
  --radius-lg: 0.75rem;
  --radius-xl: 1rem;

  /* Shadows */
  --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
  --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1);
  --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1);
  --shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1);

  /* Motion */
  --animate-duration-fast: 150ms;
  --animate-duration-normal: 200ms;
  --animate-duration-slow: 300ms;
}

@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 0 0% 3.9%;
    /* ... all Shadcn HSL vars for light ... */
  }
  .dark {
    --background: 0 0% 3.9%;
    --foreground: 0 0% 98%;
    /* ... all Shadcn HSL vars for dark ... */
  }
  * { @apply border-border; }
  body { @apply bg-background text-foreground; }
}
```

#### 2. app/layout.tsx

```tsx
import type { Metadata } from "next"
import { {Font} } from "next/font/google"
import { ThemeProvider } from "@/components/theme-provider"
import "@/styles/globals.css"

const fontSans = {Font}({
  subsets: ["latin"],
  variable: "--font-sans",
})

export const metadata: Metadata = {
  title: "{App Name}",
  description: "{description}",
}

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body className={`${fontSans.variable} font-sans antialiased`}>
        <ThemeProvider attribute="class" defaultTheme="system" enableSystem>
          {children}
        </ThemeProvider>
      </body>
    </html>
  )
}
```

#### 3. components.json

```json
{
  "$schema": "https://ui.shadcn.com/schema.json",
  "style": "new-york",
  "tailwind": {
    "config": "",
    "css": "styles/globals.css",
    "baseColor": "{baseColor}"
  },
  "aliases": {
    "components": "@/components",
    "utils": "@/lib/utils",
    "ui": "@/components/ui",
    "hooks": "@/hooks"
  }
}
```

#### 4. Recommended folder structure

```
app/
├── layout.tsx          ← font + theme provider
├── page.tsx
├── globals.css         ← @theme + Shadcn vars
components/
├── ui/                 ← Shadcn components (npx shadcn add)
├── layouts/            ← Sidebar, Navbar, PageHeader
├── forms/              ← Form compositions
└── {feature}/          ← Feature-specific components
lib/
├── utils.ts            ← cn() helper
hooks/                  ← Custom hooks
styles/
└── globals.css
```

#### 5. Shadcn install commands

List only the components that were identified in the component inventory:

```bash
npx shadcn@latest init
npx shadcn@latest add {space-separated list of identified components}
```

---

## Rules

- **Be specific.** Use real values extracted from the source, not generic placeholders.
- **Be complete.** Cover all 10 extraction dimensions and all 3 output parts.
- **Be actionable.** The output should be copy-paste ready for bootstrapping a project.
- **Infer intelligently.** If something isn't directly visible (e.g., dark mode, hover states), make educated inferences based on the visual style.
- **Map to Shadcn.** Every component should reference its Shadcn equivalent when one exists.
- If no argument is specified, ask the user what to analyze.
