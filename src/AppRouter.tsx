import { useRouter, Routes } from './router.js';
import { HomePage } from './pages/HomePage.jsx';
import { ProfilePage } from './pages/ProfilePage.jsx';
import { MessagesPage } from './pages/MessagePage.jsx';
import { ProjectDetailsPage } from './pages/ProjectDetailsPage.jsx';
//import { SettingsPage } from './pages/SettingsPage.jsx';
//import { CreateProjectPage } from './pages/CreateProjectPage.jsx';

export function AppRouter() {
  const { currentRoute, params } = useRouter();

  switch (currentRoute) {
    case Routes.HOME:
      return <HomePage />;
    case Routes.PROFILE:
      return <ProfilePage />;
    case Routes.MESSAGES:
      return <MessagesPage />;
    case Routes.PROJECT_DETAILS:
      return <ProjectDetailsPage projectId={params.projectId} />;
    //case Routes.SETTINGS:
      //return <SettingsPage />;
    //case Routes.CREATE_PROJECT:
      //return <CreateProjectPage />;
    default:
      return <HomePage />;
  }
}