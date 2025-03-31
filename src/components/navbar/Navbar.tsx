// src/components/navbar/Navbar.tsx
import { useCallback } from '@lynx-js/react'
import { useRouter, Routes } from '../../router.js'
import Logo from '../../assets/icons/LogoS.png';
import Profile from '../../assets/icons/ProfileIcon.png';
import Message from '../../assets/icons/MessageIcon.png';

export function Navbar() {
  const { navigate } = useRouter();
  
  const handleHomeClick = useCallback(() => {
    'background only'
    navigate(Routes.HOME);
  }, [navigate])
  
  const handleProfileClick = useCallback(() => {
    'background only'
    navigate(Routes.PROFILE);
  }, [navigate])
  
  const handleMessagesClick = useCallback(() => {
    'background only'
    navigate(Routes.MESSAGES);
  }, [navigate])

  return (
    <view className="p-4 bg-white shadow-md">
      <view className="flex justify-around">
        <image 
          src={Profile} 
          className="h-10 w-10"
          bindtap={handleProfileClick}
        />
        <image 
          src={Logo}
          className="w-10 h-10"
          bindtap={handleHomeClick}
        />
        <image 
          src={Message}
          className="w-8 h-8"
          bindtap={handleMessagesClick}
        />
      </view>
    </view>
  )
}