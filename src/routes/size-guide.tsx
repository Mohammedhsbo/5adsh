import { createFileRoute, Link } from "@tanstack/react-router";

export const Route = createFileRoute("/size-guide")({ component: SizeGuidePage });

const apparelSizes = [
  ["S", "92 cm", "76 cm", "68 cm"],
  ["M", "98 cm", "82 cm", "70 cm"],
  ["L", "104 cm", "88 cm", "72 cm"],
  ["XL", "110 cm", "94 cm", "74 cm"],
];

function SizeGuidePage() {
  return (
    <main className="mx-auto max-w-[1200px] px-4 py-12 md:px-8 md:py-20">
      <header className="max-w-3xl">
        <p className="font-mono text-xs uppercase tracking-[0.3em] text-muted-foreground">
          5ADSH / Fit guide
        </p>
        <h1 className="mt-4 font-display text-5xl uppercase md:text-7xl">Find your fit</h1>
        <p className="mt-5 max-w-2xl text-sm leading-7 text-muted-foreground md:text-base">
          Use the chart as a starting point, then check the available sizes on each product. Numeric
          and one-size items use the sizing shown on their product page.
        </p>
      </header>

      <section className="mt-12" aria-labelledby="apparel-size-heading">
        <div className="flex flex-wrap items-end justify-between gap-3">
          <div>
            <p className="font-mono text-[10px] uppercase tracking-[0.25em] text-muted-foreground">
              Measurements
            </p>
            <h2 id="apparel-size-heading" className="mt-2 font-display text-3xl uppercase">
              Apparel size chart
            </h2>
          </div>
          <p className="font-mono text-[10px] uppercase tracking-[0.2em] text-muted-foreground">
            Measurements in cm
          </p>
        </div>

        <div className="mt-5 overflow-x-auto border">
          <table className="w-full min-w-[560px] text-left text-sm">
            <caption className="sr-only">Apparel measurements in centimeters by size</caption>
            <thead className="bg-card font-mono text-[10px] uppercase tracking-[0.15em]">
              <tr>
                <th scope="col" className="p-4">
                  Size
                </th>
                <th scope="col" className="p-4">
                  Chest
                </th>
                <th scope="col" className="p-4">
                  Waist
                </th>
                <th scope="col" className="p-4">
                  Length
                </th>
              </tr>
            </thead>
            <tbody>
              {apparelSizes.map(([size, chest, waist, length]) => (
                <tr key={size} className="border-t">
                  <th scope="row" className="p-4 font-mono font-medium">
                    {size}
                  </th>
                  <td className="p-4 text-muted-foreground">{chest}</td>
                  <td className="p-4 text-muted-foreground">{waist}</td>
                  <td className="p-4 text-muted-foreground">{length}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        <p className="mt-3 text-xs leading-6 text-muted-foreground">
          Product fit can vary by style. If a product offers numeric sizing or a single size, use
          the options shown on that product page.
        </p>
      </section>

      <section className="mt-12 grid gap-px border bg-border md:grid-cols-3">
        <article className="bg-background p-6 md:p-8">
          <p className="font-mono text-[10px] uppercase tracking-[0.25em] text-muted-foreground">
            01 / Chest
          </p>
          <h2 className="mt-3 font-display text-2xl uppercase">Measure around</h2>
          <p className="mt-3 text-sm leading-6 text-muted-foreground">
            Wrap a soft tape around the fullest part of your chest, keeping it level and comfortably
            close.
          </p>
        </article>
        <article className="bg-background p-6 md:p-8">
          <p className="font-mono text-[10px] uppercase tracking-[0.25em] text-muted-foreground">
            02 / Waist
          </p>
          <h2 className="mt-3 font-display text-2xl uppercase">Keep it natural</h2>
          <p className="mt-3 text-sm leading-6 text-muted-foreground">
            Measure around your natural waist without pulling the tape tight. Keep it parallel to
            the floor.
          </p>
        </article>
        <article className="bg-background p-6 md:p-8">
          <p className="font-mono text-[10px] uppercase tracking-[0.25em] text-muted-foreground">
            03 / Length
          </p>
          <h2 className="mt-3 font-display text-2xl uppercase">Compare a favourite</h2>
          <p className="mt-3 text-sm leading-6 text-muted-foreground">
            Lay a similar garment flat and measure from the highest shoulder point to the hem.
          </p>
        </article>
      </section>

      <section className="mt-12 flex flex-col gap-5 border-t pt-8 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h2 className="font-display text-2xl uppercase">Still deciding?</h2>
          <p className="mt-2 text-sm text-muted-foreground">
            Check the size options on the item you want, or get in touch for help.
          </p>
        </div>
        <div className="flex flex-wrap gap-3">
          <Link
            to="/contact"
            className="border px-5 py-3 font-mono text-[10px] uppercase tracking-[0.2em] transition-colors hover:bg-accent"
          >
            Contact us
          </Link>
          <Link
            to="/products"
            className="bg-primary px-5 py-3 font-mono text-[10px] uppercase tracking-[0.2em] text-primary-foreground transition-colors hover:bg-primary/90"
          >
            Shop all
          </Link>
        </div>
      </section>
    </main>
  );
}
