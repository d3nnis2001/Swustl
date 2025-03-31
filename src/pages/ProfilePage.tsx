// src/pages/ProfilePage.tsx
import { useRouter, Routes } from '../router.js'

export function ProfilePage() {
  const { navigate } = useRouter();

  const handleCreateProject = () => {
    navigate(Routes.CREATE_PROJECT);
  }

  const handleSettings = () => {
    navigate(Routes.SETTINGS);
  }

  return (
    <view className="p-4 flex flex-col">
      <view className="bg-white rounded-xl shadow-md p-6 mb-4">
        <view className="flex items-center mb-4">
          <view className="w-20 h-20 bg-gray-300 rounded-full mr-4"></view>
          <view>
            <text className="text-xl font-bold">Max Mustermann</text>
            <text className="text-gray-600">Full-Stack Developer</text>
          </view>
        </view>
        
        <view className="mb-4">
          <text className="font-bold mb-1">Über mich</text>
          <text className="text-gray-700">Full-Stack Entwickler mit 5 Jahren Erfahrung. Spezialisiert auf React, Node.js und TypeScript.</text>
        </view>
        
        <view className="mb-4">
          <text className="font-bold mb-1">Skills</text>
          <view className="flex flex-wrap gap-2">
            <view className="bg-blue-100 text-blue-800 px-2 py-1 rounded">React</view>
            <view className="bg-blue-100 text-blue-800 px-2 py-1 rounded">TypeScript</view>
            <view className="bg-blue-100 text-blue-800 px-2 py-1 rounded">Node.js</view>
            <view className="bg-blue-100 text-blue-800 px-2 py-1 rounded">MongoDB</view>
          </view>
        </view>
        
        <view className="mb-4">
          <text className="font-bold mb-1">Verfügbarkeit</text>
          <text className="text-gray-700">10-15 Stunden/Woche</text>
        </view>
      </view>
      
      <view 
        className="bg-white rounded-xl shadow-md p-4 mb-4 flex items-center"
        bindtap={handleCreateProject}
      >
        <view className="w-10 h-10 bg-blue-500 rounded-full flex items-center justify-center mr-4">
          <text className="text-white text-xl">+</text>
        </view>
        <text className="font-bold">Neues Projekt erstellen</text>
      </view>
      
      <view 
        className="bg-white rounded-xl shadow-md p-4 flex items-center"
        bindtap={handleSettings}
      >
        <view className="w-10 h-10 bg-gray-200 rounded-full flex items-center justify-center mr-4">
          <text className="text-gray-600 text-xl">⚙️</text>
        </view>
        <text className="font-bold">Einstellungen</text>
      </view>
    </view>
  )
}