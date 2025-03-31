// src/pages/MessagesPage.tsx
import { useState } from '@lynx-js/react'
import { useRouter, Routes } from '../router.js'

interface ChatMessage {
  id: number;
  senderId: number;
  text: string;
  timestamp: string;
}

interface ChatContact {
  id: number;
  name: string;
  lastMessage: string;
  lastMessageTime: string;
  unreadCount: number;
  imageUrl: string;
}

// Beispieldaten
const contacts: ChatContact[] = [
  {
    id: 1,
    name: "Sarah - KI-Lernportal",
    lastMessage: "Kannst du mir mehr über deine React-Erfahrung erzählen?",
    lastMessageTime: "14:25",
    unreadCount: 2,
    imageUrl: ""
  },
  {
    id: 2,
    name: "Tim - E-Commerce App",
    lastMessage: "Hast du schon mal mit Flutter gearbeitet?",
    lastMessageTime: "Gestern",
    unreadCount: 0,
    imageUrl: ""
  },
  {
    id: 3,
    name: "Julia - Game Engine",
    lastMessage: "Wir haben gerade ein neues Feature implementiert!",
    lastMessageTime: "Montag",
    unreadCount: 0,
    imageUrl: ""
  }
];

export function MessagesPage() {
  const { navigate } = useRouter();
  
  const handleContactClick = (contactId: number) => {
    navigate(Routes.PROJECT_DETAILS, { projectId: contactId, showChat: true });
  };

  return (
    <view className="flex flex-col h-full">
      <view className="p-4 bg-white shadow-sm">
        <text className="text-xl font-bold">Nachrichten</text>
      </view>
      
      <view className="flex-1 overflow-auto">
        {contacts.map(contact => (
          <view 
            key={contact.id}
            className="p-4 border-b flex items-center"
            bindtap={() => handleContactClick(contact.id)}
          >
            <view className="w-12 h-12 bg-gray-300 rounded-full mr-3"></view>
            
            <view className="flex-1">
              <view className="flex justify-between">
                <text className="font-bold">{contact.name}</text>
                <text className="text-sm text-gray-500">{contact.lastMessageTime}</text>
              </view>
              
              <view className="flex justify-between">
                <text className="text-gray-600 text-sm truncate">{contact.lastMessage}</text>
                {contact.unreadCount > 0 && (
                  <view className="bg-blue-500 text-white rounded-full w-5 h-5 flex items-center justify-center">
                    <text className="text-xs">{contact.unreadCount}</text>
                  </view>
                )}
              </view>
            </view>
          </view>
        ))}
      </view>
    </view>
  )
}