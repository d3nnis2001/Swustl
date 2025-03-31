// components/profile/ProfileCard.tsx
import { useCallback, useState } from '@lynx-js/react'
import { type ProfileType, type SwipeDirection, type LynxTouchEvent, type SwipeHandlers } from '../../types.js'
import { ProfileImageGallery } from './ProfileImageGallery.jsx'
import { ProfileStatusLabel } from './ProfileStatusLabel.jsx'
import { ProfileInfo } from './ProfileInfo.jsx'

interface ProfileCardProps extends SwipeHandlers {
  profile: ProfileType;
}

export function ProfileCard({ profile }: ProfileCardProps) {
  const [currentImageIndex, setCurrentImageIndex] = useState<number>(0)
  const [swipeDirection, setSwipeDirection] = useState<SwipeDirection>(null)
  const [startX, setStartX] = useState<number>(0)
  const [offsetX, setOffsetX] = useState<number>(0)
  const [isSwiping, setIsSwiping] = useState<boolean>(false)

  // Registers a touch (potential swipe)
  const onTouchStart = useCallback((e: LynxTouchEvent) => {
    'background only'
    setStartX(e.touches[0].clientX)
    setIsSwiping(true)
  }, [])
  
  // Checks if the current swipe is a left or right swipe
  const onTouchMove = useCallback((e: LynxTouchEvent) => {
    'background only'
    if (isSwiping) {
      const currentX = e.touches[0].clientX
      const diff = currentX - startX
      setOffsetX(diff)
      
      if (diff > 50) {
        setSwipeDirection('right')
      } else if (diff < -50) {
        setSwipeDirection('left')
      } else {
        setSwipeDirection(null)
      }
    }
  }, [isSwiping, startX])

  const onTouchEnd = useCallback(() => {
    'background only'
    if (isSwiping) {
      if (swipeDirection === 'right' || swipeDirection === 'left') {
        onNext()
      }
      
      setIsSwiping(false)
      setOffsetX(0)
      setSwipeDirection(null)
    }
  }, [isSwiping, swipeDirection, onNext])

  const getCardStyle = () => {
    const rotationAngle = offsetX * 0.1
    return {
      transform: `translateX(${offsetX}px) rotate(${rotationAngle}deg)`,
      transition: isSwiping ? 'none' : 'transform 0.3s ease'
    } as React.CSSProperties
  }

  return (
    <view 
      className="bg-white w-full max-w-sm rounded-xl overflow-hidden shadow-xl relative"
      style={getCardStyle() as any}
      bindtouchstart={onTouchStart}
      bindtouchmove={onTouchMove}
      bindtouchend={onTouchEnd}
    >
      {swipeDirection === 'right' && (
        <view className="absolute top-5 left-5 z-10 rotate-[-30deg] border-4 border-green-500 p-2 rounded-lg">
          <text className="text-green-500 font-bold text-3xl">LIKE</text>
        </view>
      )}
      
      {swipeDirection === 'left' && (
        <view className="absolute top-5 right-5 z-10 rotate-[30deg] border-4 border-red-500 p-2 rounded-lg">
          <text className="text-red-500 font-bold text-3xl">NOPE</text>
        </view>
      )}
      
      <view className="relative h-96 bg-gray-300">
        <ProfileStatusLabel status={profile.status} />
        
        <ProfileImageGallery 
          images={profile.images}
          currentIndex={currentImageIndex}
          onSetCurrentIndex={setCurrentImageIndex}
        />
        
        <view className="absolute bottom-0 left-0 right-0 p-4 z-10">
          <ProfileInfo name={profile.name} age={profile.age} bio={profile.bio} />
        </view>
      </view>
    </view>
  )
}