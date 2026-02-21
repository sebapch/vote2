/** @type {import('tailwindcss').Config} */
export default {
    content: [
        "./index.html",
        "./src/**/*.{vue,js,ts,jsx,tsx}",
    ],
    theme: {
        extend: {
            colors: {
                primary: "#3b82f6",
                secondary: "#ec4899",
            },
            animation: {
                'swipe-right': 'swipe-right 0.5s ease-out forwards',
                'swipe-left': 'swipe-left 0.5s ease-out forwards',
            },
            keyframes: {
                'swipe-right': {
                    '0%': { transform: 'translateX(0) rotate(0)', opacity: '1' },
                    '100%': { transform: 'translateX(200%) rotate(20deg)', opacity: '0' },
                },
                'swipe-left': {
                    '0%': { transform: 'translateX(0) rotate(0)', opacity: '1' },
                    '100%': { transform: 'translateX(-200%) rotate(-20deg)', opacity: '0' },
                },
            }
        },
    },
    plugins: [],
}
