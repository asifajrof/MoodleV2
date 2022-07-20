/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*.{html,js}"],
  theme: {
    colors: {
    'gray-light': '#D3D3D3',
    'white': '#FFFFFF',
    'blue': '#1fb6ff',
    'gray-dark': '#273444',
    'gray': '#8492a6',
    'orange': '#ff7849',
    'purple': '#7e5bef',
    'pink': '#ff49db',
    'green': '#13ce66',
    'yellow': '#ffc82c',
    },
    fontFamily: {
      sans: ['Graphik', 'sans-serif'],
      serif: ['Merriweather', 'serif'],
    },
    extend: {
      spacing: {
        '8xl': '96rem',
        '9xl': '128rem',
      },
      borderRadius: {
        '4xl': '2rem',
      }
    }
  },
  plugins: [],
}
