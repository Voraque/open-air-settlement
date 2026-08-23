import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'Open-Air Settlement — Field Guide',
  description: 'A small, practical guide to the Open-Air Settlement Minecraft modpack.',
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
