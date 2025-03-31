import "./Profile.css";

interface ProfileInfoProps {
    name: string;
    age: number;
    bio: string;
  }
  
  export function ProfileInfo({ name, age, bio }: ProfileInfoProps) {
    return (
      <view className="z-10 flex flex-col">
        <view className="flex items-center">
          <text className="text-xl white_color font-bold drop-shadow-lg">{name}</text>
          <text className="ml-2 text-lg white_color drop-shadow-lg">{age}</text>
        </view>
        <text className=" mt-1 white_color drop-shadow-lg">{bio}</text>
      </view>
    )
  }