import { Link } from "@tanstack/react-router";
import { Menu, Search, ShieldCheck, ShoppingBag, UserRound, X } from "lucide-react";
import { useState } from "react";

import { Wordmark } from "@/components/Wordmark";

const categoryLinks = [
  { label: "MEN", to: "/products/men" },
  { label: "WOMEN", to: "/products/women" },
  { label: "KIDS", to: "/products/kids" },
  { label: "DROPS", to: "/products/new-drops" },
];

export function StoreNavbar() {
  const [menuOpen, setMenuOpen] = useState(false);

  return (
    <>
      <header className="sticky top-0 z-40 border-b bg-background/90 backdrop-blur">
        <div className="mx-auto flex max-w-[1600px] items-center justify-between px-4 py-3 md:px-8">
          <nav
            aria-label="Product categories"
            className="hidden gap-6 font-mono text-xs tracking-widest md:flex"
          >
            {categoryLinks.map((item) => (
              <Link
                key={item.label}
                to={item.to}
                className="relative after:absolute after:-bottom-1 after:left-0 after:h-px after:w-0 after:bg-foreground after:transition-all hover:after:w-full"
              >
                {item.label}
              </Link>
            ))}
          </nav>

          <button
            type="button"
            className="md:hidden"
            onClick={() => setMenuOpen(true)}
            aria-label="Open navigation menu"
          >
            <Menu />
          </button>

          <Link to="/" aria-label="5ADSH home">
            <Wordmark className="text-3xl md:text-4xl" />
          </Link>

          <div className="flex items-center gap-4">
            <Link to="/products" aria-label="Search products">
              <Search className="hidden h-5 w-5 md:block" />
            </Link>
            <Link to="/cart" aria-label="Shopping cart">
              <ShoppingBag className="h-5 w-5" />
            </Link>
            <Link to="/login" aria-label="User sign in">
              <UserRound className="h-5 w-5" />
            </Link>
            <Link to="/admin/login" aria-label="Administrator sign in">
              <ShieldCheck className="h-5 w-5" />
            </Link>
          </div>
        </div>
      </header>

      {menuOpen ? (
        <div className="fixed inset-0 z-50 flex flex-col bg-primary p-6 text-primary-foreground animate-rise md:hidden">
          <button
            type="button"
            className="self-end"
            onClick={() => setMenuOpen(false)}
            aria-label="Close navigation menu"
          >
            <X />
          </button>
          <nav aria-label="Mobile navigation" className="mt-8 flex flex-col gap-2">
            {[
              { label: "Home", to: "/" },
              { label: "All products", to: "/products" },
              ...categoryLinks.map(({ label, to }) => ({ label, to })),
              { label: "Cart", to: "/cart" },
              { label: "User sign in", to: "/login" },
              { label: "Admin sign in", to: "/admin/login" },
            ].map((item) => (
              <Link
                key={item.label}
                to={item.to}
                onClick={() => setMenuOpen(false)}
                className="font-display text-4xl uppercase"
              >
                {item.label}
              </Link>
            ))}
          </nav>
        </div>
      ) : null}
    </>
  );
}
