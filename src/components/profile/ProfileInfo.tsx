interface ProfileInfoProps {
    name: string;
    age: number;
    bio: string;
  }
  
  export function ProfileInfo({ name, age, bio }: ProfileInfoProps) {
    return (
      <view className="z-10">
        <view className="flex items-center">
          <text className="text-xl font-bold text-white drop-shadow-lg">{name}</text>
          <text className="ml-2 text-lg text-white drop-shadow-lg">{age}</text>
        </view>
        <text className="text-white mt-1 drop-shadow-lg">{bio}</text>
      </view>
    )
  }