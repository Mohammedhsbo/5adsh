import { Link } from "@tanstack/react-router";

import { Wordmark } from "@/components/Wordmark";

export function StoreFooter() {
  return (
    <footer className="bg-primary px-4 pt-16 text-primary-foreground md:px-8">
      <div className="mx-auto max-w-[1600px]">
        <div className="grid gap-10 border-b border-primary-foreground/20 pb-12 md:grid-cols-4">
          <div className="md:col-span-2">
            <p className="font-display text-3xl uppercase">Get scratched first.</p>
            <form
              onSubmit={(event) => event.preventDefault()}
              className="mt-4 flex max-w-md border border-primary-foreground/40"
            >
              <input
                placeholder="EMAIL"
                className="flex-1 bg-transparent px-4 py-3 font-mono text-sm outline-none placeholder:text-primary-foreground/50"
              />
              <button className="bg-primary-foreground px-5 font-mono text-xs text-primary">
                JOIN
              </button>
            </form>
          </div>
          <ul className="space-y-2 font-mono text-xs tracking-widest opacity-70">
            {(
              [
                ["Shipping", "/shipping"],
                ["Returns", "/returns"],
                ["Size guide", "/size-guide"],
                ["Contact", "/contact"],
              ] as const
            ).map(([label, href]) => (
              <li key={label}>
                <Link to={href}>{label.toUpperCase()}</Link>
              </li>
            ))}
          </ul>
          <ul className="space-y-2 font-mono text-xs tracking-widest opacity-70">
            {(
              [
                ["Instagram", "https://instagram.com"],
                ["TikTok", "https://tiktok.com"],
                ["Cairo, EG", "/contact"],
              ] as const
            ).map(([label, href]) => (
              <li key={label}>
                {href.startsWith("http") ? (
                  <a href={href} target="_blank" rel="noreferrer">
                    {label.toUpperCase()}
                  </a>
                ) : (
                  <Link to="/contact">{label.toUpperCase()}</Link>
                )}
              </li>
            ))}
          </ul>
        </div>
        <Link
          to="/"
          aria-label="5ADSH home"
          className="relative block py-6 leading-[0.8] [--background:var(--ink)]"
        >
          <Wordmark arabic={false} className="text-[27vw] xl:text-[420px]" />
        </Link>
        <p className="pb-6 font-mono text-[10px] tracking-widest opacity-50">
          © 2026 5ADSH — خدش. ALL MARKS RESERVED.
        </p>
      </div>
    </footer>
  );
}
