import {React} from 'react';
import { BrowserRouter, Routes, Route, useNavigate } from 'react-router-dom';
import { useState,Suspense,lazy } from 'react';
const Admin = lazy(()=>import('./Pages/Admin'))  
const Donar = lazy(()=>import('./Pages/Donar'))

import './App.css';
import FundMeApp from './FundMeApp';

function App(){
  return(
    <BrowserRouter>
      <AppData />
      <Routes>
        <Route path="/Admin" element={<Suspense fallback={"Loading.."}><Admin /></Suspense>} />
        <Route path="/Donar" element={<Suspense fallback={"Loading.."}><Donar /></Suspense>} />
      </Routes>
    </BrowserRouter>
  );
}

function AppData(){
  const navigate = useNavigate();
  const [connected, setConnected] = useState(false);
  return(
    <div className='App_Parent'>
      <button onClick={async function(){
          if (typeof window.ethereum !== "undefined") {
            try {
              await window.ethereum.request({ method: "eth_requestAccounts" });
              setConnected(true);
            } catch (error) {
              console.error(error);
            }
          } else {
            alert("Please install MetaMask");
          }
      }}
      >Connect Wallet
      </button>
      {connected && (
        <>
          <div>
            <button onClick={()=>{
              navigate("/Admin");
          }}
          >Admin</button>
          </div>
          <div>
            <button onClick={()=>{
              navigate("/Donar");
            }}
            >Donar</button>
          </div>
        </>
      )}
    </div>
  );
}

export default App;