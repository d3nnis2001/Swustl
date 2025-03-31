import { useCallback } from '@lynx-js/react'
import Logo from '../../assets/icons/LogoS.png';
import Profile from '../../assets/icons/ProfileIcon.png';
import Message from '../../assets/icons/MessageIcon.png';

type NavbarProps = {
  onRoute1Click?: () => void;
  onRoute2Click?: () => void;
}

export function Navbar({ 
  onRoute1Click,
  onRoute2Click
}: NavbarProps) {
  
  const handleRoute1Click = useCallback(() => {
    'background only'
    if (onRoute1Click) onRoute1Click()
  }, [onRoute1Click])
  
  const handleRoute2Click = useCallback(() => {
    'background only'
    if (onRoute2Click) onRoute2Click()
  }, [onRoute2Click])

  return (
    <view className="p-4 bg-white shadow-md">
      <view className="flex justify-around">
        <image 
          src={Profile} 
          className="h-10 w-10"
          bindtap={handleRoute1Click}
        />
        <image 
          src={Logo}
          className="w-10 h-10"
        />
        <image 
          src={Message}
          className="w-8 h-8"
          bindtap={handleRoute2Click}
        />
      </view>
    </view>
  )
}