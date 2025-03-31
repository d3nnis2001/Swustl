import { useState } from '@lynx-js/react'
import { useRouter, Routes } from '../router.js'
import { MatchStatus } from '../types.js'
import img1 from "../assets/images/1.jpg"
import img2 from "../assets/images/2.jpg"
import img3 from "../assets/images/3.jpg"
import img4 from "../assets/images/4.jpg"
import img5 from "../assets/images/5.jpg"
import img6 from "../assets/images/6.jpg"
import img7 from "../assets/images/7.jpg"
import img8 from "../assets/images/8.jpg"
import img9 from "../assets/images/9.jpg"
import "./ProjectDetailsPage.css"

const projectsData = [
  {
    id: 1,
    name: 'KI-gestütztes Lernportal',
    age: 2, 
    bio: 'Suche Frontend-Entwickler mit React-Erfahrung für ein adaptives Lernportal',
    description: 'Wir entwickeln eine Plattform, die KI nutzt, um Lernmaterialien an die Bedürfnisse der Nutzer anzupassen. Unser Tech-Stack umfasst React für das Frontend, Node.js für das Backend und TensorFlow für die KI-Komponenten.',
    images: [img1, img2, img3],
    status: MatchStatus.NEW,
    techStack: ['React', 'Node.js', 'TensorFlow', 'MongoDB'],
    teamSize: 3,
    lookingFor: ['Frontend Developer', 'UX Designer'],
    timeCommitment: '10-15 Stunden/Woche',
    contactPerson: 'Sarah Miller'
  },
  {
    id: 2,
    name: 'E-Commerce Mobile App',
    age: 4,
    bio: 'Flutter/Dart Entwickler gesucht für innovative Shopping-App',
    description: 'Eine mobile App, die lokale Geschäfte mit Kunden verbindet. Wir nutzen Flutter für die Cross-Platform-Entwicklung und Firebase für Backend-Dienste.',
    images: [img4, img5, img6],
    status: MatchStatus.FAVORITE,
    techStack: ['Flutter', 'Dart', 'Firebase', 'Google Maps API'],
    teamSize: 2,
    lookingFor: ['Mobile Developer', 'Backend Developer'],
    timeCommitment: '15-20 Stunden/Woche',
    contactPerson: 'Tim Johnson'
  },
  {
    id: 3,
    name: 'Open-Source Game Engine',
    age: 8,
    bio: 'C++/OpenGL Kenntnisse erforderlich. Bereits 3 Mitwirkende im Team',
    description: 'Eine leichtgewichtige Open-Source-Spiel-Engine für 2D und einfache 3D-Spiele. Wir verwenden C++ und OpenGL für Rendering.',
    images: [img7, img8, img9],
    status: MatchStatus.SUPER_LIKE,
    techStack: ['C++', 'OpenGL', 'CMake', 'Python'],
    teamSize: 5,
    lookingFor: ['C++ Developer', 'Game Designer', 'Documentation Specialist'],
    timeCommitment: '5-10 Stunden/Woche',
    contactPerson: 'Julia Chen'
  }
];

interface ProjectDetailsPageProps {
  projectId?: number;
  showChat?: boolean;
}

export function ProjectDetailsPage({ projectId = 1, showChat = false }: ProjectDetailsPageProps) {
  const { navigate } = useRouter();
  const [activeTab, setActiveTab] = useState<'details' | 'chat'>(showChat ? 'chat' : 'details');
  const [message, setMessage] = useState('');
  
  // Finde das Projekt anhand der ID
  const project = projectsData.find(p => p.id === projectId) || projectsData[0];
  
  const handleBack = () => {
    navigate(Routes.HOME);
  };
  
  const handleMatch = () => {
    // Hier würde die Match-Logik implementiert werden
    alert('Du hast Interesse an diesem Projekt bekundet!');
    navigate(Routes.MESSAGES);
  };

  return (
    <view className="flex flex-col h-full">
      {/* Header mit Zurück-Button */}
      <view className="bg-white p-4 flex items-center shadow-sm">
        <view className="w-8 h-8 flex items-center justify-center" bindtap={handleBack}>
          <text className="text-xl">&lt;</text>
        </view>
        <text className="ml-4 text-lg font-bold flex-1">{project.name}</text>
      </view>
      
      {/* Tabs */}
      <view className="flex border-b bg-white">
        <view 
          className={`flex-1 py-3 text-center ${activeTab === 'details' ? 'border-b-2 border-blue-500 font-bold' : ''}`}
          bindtap={() => setActiveTab('details')}
        >
          <text>Details</text>
        </view>
        <view 
          className={`flex-1 py-3 text-center ${activeTab === 'chat' ? 'border-b-2 border-blue-500 font-bold' : ''}`}
          bindtap={() => setActiveTab('chat')}
        >
          <text>Chat</text>
        </view>
      </view>
      
      {/* Content */}
      <view className="flex-1 overflow-auto">
        {activeTab === 'details' ? (
          <view className="p-4">
            {/* Projektbilder */}
            <view className="mb-4 h-48 bg-gray-200 rounded-lg overflow-hidden">
              <image src={project.images[0]} className="w-full h-full" />
            </view>
            
            {/* Projektinfo */}
            <view className="bg-white rounded-lg shadow p-4 mb-4">
              <text className="font-bold text-lg mb-2">{project.name}</text>
              <text className="text-gray-700 mb-4">{project.description}</text>
              
              <view className="mb-3">
                <text className="font-bold mb-1">Tech Stack:</text>
                <view className="flex flex-wrap gap-2">
                  {project.techStack.map((tech, index) => (
                    <view key={index} className="bg-blue-100 text-blue-800 px-2 py-1 rounded">
                      <text>{tech}</text>
                    </view>
                  ))}
                </view>
              </view>
              
              <view className="mb-3">
                <text className="font-bold mb-1">Wir suchen:</text>
                <view className="flex flex-wrap gap-2">
                  {project.lookingFor.map((role, index) => (
                    <view key={index} className="bg-green-100 text-green-800 px-2 py-1 rounded">
                      <text>{role}</text>
                    </view>
                  ))}
                </view>
              </view>
              
              <view className="mb-3">
                <text className="font-bold">Zeitaufwand:</text>
                <text className="text-gray-700"> {project.timeCommitment}</text>
              </view>
              
              <view className="mb-3">
                <text className="font-bold">Teamgröße:</text>
                <text className="text-gray-700"> {project.teamSize} Personen</text>
              </view>
              
              <view>
                <text className="font-bold">Kontakt:</text>
                <text className="text-gray-700"> {project.contactPerson}</text>
              </view>
            </view>
            
            {/* Action Buttons */}
            <view className="flex gap-3">
              <view 
                className="flex-1 bg-gray-200 rounded-lg p-3 flex justify-center items-center"
                bindtap={handleBack}
              >
                <text className="font-bold">Zurück</text>
              </view>
              <view 
                className="flex-1 bg-blue-500 text-white rounded-lg p-3 flex justify-center items-center"
                bindtap={handleMatch}
              >
                <text className="font-bold">Interesse bekunden</text>
              </view>
            </view>
          </view>
        ) : (
          // Chat-Ansicht
          <view className="flex flex-col h-full">
            <view className="flex-1 p-4 overflow-auto">
              {/* Hier würden Chat-Nachrichten angezeigt */}
              <view className="bg-gray-200 rounded-lg p-3 mb-2 max-w-xs">
                <text>Hallo! Ich bin interessiert an deinem Projekt. Kannst du mir mehr Details geben?</text>
              </view>
              
              <view className="bg-blue-500 text-white rounded-lg p-3 mb-2 max-w-xs ml-auto">
                <text>Natürlich! Wir suchen einen Frontend-Entwickler mit React-Erfahrung.</text>
              </view>
              
              <view className="bg-gray-200 rounded-lg p-3 mb-2 max-w-xs">
                <text>Perfekt! Ich habe 3 Jahre Erfahrung mit React. Wie viel Zeit pro Woche wäre erforderlich?</text>
              </view>
            </view>
            
            {/* Nachrichteneingabe */}
            <view className="p-4 border-t">
              <view className="flex">
                <input
                  className="flex-1 bg-gray-100 rounded-full py-2 px-4"
                  placeholder="Nachricht schreiben..."
                  value={message}
                  onChange={(e: any) => setMessage(e.target.value)}
                />
                <view className="ml-2 w-10 h-10 bg-blue-500 rounded-full flex items-center justify-center">
                  <text className="text-white">→</text>
                </view>
              </view>
            </view>
          </view>
        )}
      </view>
    </view>
  )
}