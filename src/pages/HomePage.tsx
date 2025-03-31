// src/pages/HomePage.tsx
import { useState } from '@lynx-js/react'
import { ProfileCard } from "../components/profile/ProfileCard.jsx"
import { ActionButtons } from "../components/buttons/ActionButtons.jsx"
import { MatchStatus, type ProfileType } from "../types.js"
import img1 from "../assets/images/1.jpg"
import img2 from "../assets/images/2.jpg"
import img3 from "../assets/images/3.jpg"
import img4 from "../assets/images/4.jpg"
import img5 from "../assets/images/5.jpg"
import img6 from "../assets/images/6.jpg"
import img7 from "../assets/images/7.jpg"
import img8 from "../assets/images/8.jpg"
import img9 from "../assets/images/9.jpg"
import { useRouter, Routes } from '../router.js'

// Diese Daten würden später vom Backend kommen
const projects: ProfileType[] = [
  {
    id: 1,
    name: 'KI-gestütztes Lernportal',
    age: 2, 
    bio: 'Suche Frontend-Entwickler mit React-Erfahrung für ein adaptives Lernportal',
    images: [img1, img2, img3],
    status: MatchStatus.NEW
  },
  {
    id: 2,
    name: 'E-Commerce Mobile App',
    age: 4,
    bio: 'Flutter/Dart Entwickler gesucht für innovative Shopping-App',
    images: [img4, img5, img6],
    status: MatchStatus.FAVORITE
  },
  {
    id: 3,
    name: 'Open-Source Game Engine',
    age: 8, 
    bio: 'C++/OpenGL Kenntnisse erforderlich. Bereits 3 Mitwirkende im Team',
    images: [img7, img8, img9],
    status: MatchStatus.SUPER_LIKE
  }
]

export function HomePage() {
  const [currentProfileIndex, setCurrentProfileIndex] = useState<number>(0)
  const currentProfile = projects[currentProfileIndex]
  const { navigate } = useRouter();

  const handleNext = () => {
    setCurrentProfileIndex((prevIndex) => (prevIndex + 1) % projects.length)
  }

  const handleCardClick = () => {
    navigate(Routes.PROJECT_DETAILS, { projectId: currentProfile.id });
  }

  return (
    <>
      <view className="flex justify-center p-4">
        <view 
          bindtap={handleCardClick}
          className="w-full flex justify-center"
        >
          <ProfileCard 
            profile={currentProfile}
            onNext={handleNext}
          />
        </view>
      </view>
      
      <view className="mt-auto mb-10">
        <ActionButtons onNext={handleNext} />
      </view>
    </>
  )
}