import { useCallback } from '@lynx-js/react'
import { type Dispatch, type SetStateAction } from '@lynx-js/react';

interface ProfileImageGalleryProps {
  images: string[];
  currentIndex: number;
  onSetCurrentIndex: Dispatch<SetStateAction<number>>;
}

export function ProfileImageGallery({ images, currentIndex, onSetCurrentIndex }: ProfileImageGalleryProps) {
  const nextImage = useCallback(() => {
    'background only'
    onSetCurrentIndex((prevIndex) => (prevIndex + 1) % images.length)
  }, [images, onSetCurrentIndex])

  const prevImage = useCallback(() => {
    'background only'
    onSetCurrentIndex((prevIndex) => prevIndex === 0 ? images.length - 1 : prevIndex - 1)
  }, [images, onSetCurrentIndex])

  // Generates the dots for the amount of images
  const renderImageDots = () => {
    return images.map((_, index: number) => (
      <view 
        key={index} 
        className={`w-2 h-2 mx-1 rounded-full ${index === currentIndex ? 'bg-white' : 'bg-gray-400'}`}
        bindtap={() => onSetCurrentIndex(index)}
      />
    ))
  }

  return (
    <>
      <view className="absolute top-0 left-0 right-0 bottom-0 overflow-hidden">
        <image 
          src={images[currentIndex]} 
          className="w-full h-full"
          style={{
            objectFit: 'cover'
          }}
        />
        {/* Semi-transparenter schwarzer Overlay für bessere Textlesbarkeit am unteren Rand */}
        <view className="absolute bottom-0 left-0 right-0 h-32 bg-gradient-to-t from-black to-transparent opacity-70" />
      </view>
      
      {/* Navigation buttons for images */}
      <view className="absolute inset-y-0 left-0 flex items-center">
        <view 
          className="w-10 h-10 bg-white bg-opacity-50 rounded-full flex items-center justify-center ml-2"
          bindtap={prevImage}
        >
          <text className="text-2xl">&lt;</text>
        </view>
      </view>
      
      <view className="absolute inset-y-0 right-0 flex items-center">
        <view 
          className="w-10 h-10 bg-white bg-opacity-50 rounded-full flex items-center justify-center mr-2"
          bindtap={nextImage}
        >
          <text className="text-2xl">&gt;</text>
        </view>
      </view>
      
      <view className="absolute bottom-4 left-0 right-0 flex justify-center">
        <view className="flex">
          {renderImageDots()}
        </view>
      </view>
    </>
  )
}