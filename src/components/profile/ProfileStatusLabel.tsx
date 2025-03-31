import { MatchStatus } from '../../types.js'

interface ProfileStatusLabelProps {
  status: MatchStatus;
}

export function ProfileStatusLabel({ status }: ProfileStatusLabelProps) {
  let bgColor = "bg-gray-500";
  
  switch(status) {
    case MatchStatus.NEW:
      bgColor = "bg-blue-500";
      break;
    case MatchStatus.FAVORITE:
      bgColor = "bg-yellow-500";
      break;
    case MatchStatus.SUPER_LIKE:
      bgColor = "bg-purple-500";
      break;
    case MatchStatus.MATCHED:
      bgColor = "bg-green-500";
      break;
    case MatchStatus.UNAVAILABLE:
      bgColor = "bg-red-500";
      break;
  }
  
  return (
    <view className="absolute top-4 left-0 right-0 flex justify-center z-10">
      <view className={`${bgColor} px-4 py-1 rounded-full shadow-lg`}>
        <text className="text-white font-bold">{status}</text>
      </view>
    </view>
  )
}