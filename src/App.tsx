// App.tsx
import { useState } from '@lynx-js/react'
import './App.css'
import img1 from "./assets/images/1.jpg"
import img2 from "./assets/images/2.jpg"
import img3 from "./assets/images/3.jpg"
import img4 from "./assets/images/4.jpg"
import img5 from "./assets/images/5.jpg"
import img6 from "./assets/images/6.jpg"
import img7 from "./assets/images/7.jpg"
import img8 from "./assets/images/8.jpg"
import img9 from "./assets/images/9.jpg"
import { Navbar } from "./components/navbar/Navbar.jsx"
import { ProfileCard } from "./components/profile/ProfileCard.jsx"
import { ActionButtons } from "./components/buttons/ActionButtons.jsx"
import { type ProfileType, MatchStatus } from "./types.js"

const profiles: ProfileType[] = [
  {
    id: 1,
    name: 'Alex',
    age: 28,
    bio: 'Liebt Wandern und gute Bücher',
    images: [img1, img2, img3],
    status: MatchStatus.NEW
  },
  {
    id: 2,
    name: 'Taylor',
    age: 25,
    bio: 'Foodie und Reiseliebhaber',
    images: [img4, img5, img6],
    status: MatchStatus.FAVORITE
  },
  {
    id: 3,
    name: 'Jordan',
    age: 30,
    bio: 'Musik, Filme und Abenteuer',
    images: [img7, img8, img9],
    status: MatchStatus.SUPER_LIKE
  }
]

export function App() {
  const [currentProfileIndex, setCurrentProfileIndex] = useState<number>(0)
  const currentProfile = profiles[currentProfileIndex]

  const handleNext = () => {
    setCurrentProfileIndex((prevIndex) => (prevIndex + 1) % profiles.length)
  }

  return (
    <view className="bg-gray-100 w-full h-full">
      <Navbar />
      <view className="flex flex-col h-full">
        <view className="flex-1 flex items-center justify-center p-4">
          <ProfileCard 
            profile={currentProfile}
            onNext={handleNext}
          />
        </view>
        
        <view className="p-4 bg-white shadow-inner">
          <ActionButtons onNext={handleNext} />
        </view>
      </view>
    </view>
  )
}