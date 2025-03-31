// components/buttons/ActionButtons.tsx
import { useCallback } from '@lynx-js/react'
import { SwipeHandlers } from '../../types'

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
        className="w-14 h-14 rounded-full bg-white border border-gray-300 shadow-md flex items-center justify-center"
        bindtap={handleNope}
      >
        <view className="text-3xl text-red-500">✕</view>
      </view>
      
      <view 
        className="w-12 h-12 rounded-full bg-white border border-gray-300 shadow-md flex items-center justify-center"
        bindtap={handleSuperLike}
      >
        <view className="text-2xl text-blue-500">★</view>
      </view>
      
      <view 
        className="w-14 h-14 rounded-full bg-white border border-gray-300 shadow-md flex items-center justify-center"
        bindtap={handleLike}
      >
        <view className="text-3xl text-green-500">♥</view>
      </view>
    </view>
  )
}