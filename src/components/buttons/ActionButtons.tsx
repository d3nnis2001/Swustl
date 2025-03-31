// components/buttons/ActionButtons.tsx
import { useCallback } from '@lynx-js/react'
import { type SwipeHandlers } from '../../types.js'
import HakenIcon from '../../assets/icons/HakenIcon.png'
import CrossIcon from '../../assets/icons/CrossIcon.png'
import "./ActionButtons.css";

export function ActionButtons({ onNext }: SwipeHandlers) {
  const handleNope = useCallback(() => {
    'background only'
    onNext()
  }, [onNext])

  const handleSuperLike = useCallback(() => {
    'background only'
    onNext()
  }, [onNext])

  const handleLike = useCallback(() => {
    'background only'
    onNext()
  }, [onNext])

  return (
    <view className="flex justify-around">
      <view 
        className="buttonCircle"
        bindtap={handleNope}
      >
        <image 
          src={CrossIcon} 
          className="h-20 w-20"
        />
      </view>
      
      <view 
        className="buttonCircle"
        bindtap={handleLike}
      >
        <image 
          src={HakenIcon} 
          className="h-20 w-20"
        />
      </view>
    </view>
  )
}