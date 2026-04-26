import { defineConfig } from 'vite';

export default defineConfig({
  build: {
    lib: {
      entry: 'src/App.jsx',
      formats: ['iife'],
      name: 'WebUIChatPlugin',
      fileName: () => 'index.js',
    },
    outDir: 'dashboard/dist',
    emptyOutDir: false, // keep hljs-theme.css
  },
  esbuild: {
    jsxFactory: 'React.createElement',
    jsxFragment: 'React.Fragment',
  },
});
