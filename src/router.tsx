import { createContext, useContext, useState } from '@lynx-js/react';

// All routes of the app
export enum Routes {
  HOME = 'HOME',
  PROFILE = 'PROFILE',
  MESSAGES = 'MESSAGES',
  PROJECT_DETAILS = 'PROJECT_DETAILS',
  SETTINGS = 'SETTINGS',
  CREATE_PROJECT = 'CREATE_PROJECT',
}

type RouterContextType = {
  currentRoute: Routes;
  params: Record<string, any>;
  navigate: (route: Routes, params?: Record<string, any>) => void;
};

const RouterContext = createContext<RouterContextType>({
  currentRoute: Routes.HOME,
  params: {},
  navigate: () => {},
});

export const useRouter = () => useContext(RouterContext);

export function RouterProvider({ children }: { children: React.ReactNode }) {
  const [currentRoute, setCurrentRoute] = useState<Routes>(Routes.HOME);
  const [params, setParams] = useState<Record<string, any>>({});

  const navigate = (route: Routes, newParams: Record<string, any> = {}) => {
    setCurrentRoute(route);
    setParams(newParams);
  };

  return (
    <RouterContext.Provider value={{ currentRoute, params, navigate }}>
      {children}
    </RouterContext.Provider>
  );
}