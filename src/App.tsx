// App.tsx
import './App.css'
import { RouterProvider } from './router.js'
import { AppRouter } from './AppRouter.js'
import { Navbar } from "./components/navbar/Navbar.jsx"

export function App() {
  return (
    <RouterProvider>
      <view className="bg-gray-100 w-full h-full flex flex-col">
        <Navbar />
        <view className="flex flex-col flex-1">
          <AppRouter />
        </view>
      </view>
    </RouterProvider>
  )
}