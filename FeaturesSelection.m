% Well, I realy did tried running mutual information on matlab, but I had a
% wonderful error causing the entire matlab to crash. 
% I'm attaching the python file helping to decide what features to use.
% 
% 
% ------------------------------------------------------------------------
%           Access violation detected at Tue Jun 18 12:30:45 2019
% ------------------------------------------------------------------------
% 
% Configuration:
%   Crash Decoding      : Disabled - No sandbox or build area path
%   Crash Mode          : continue (default)
%   Current Graphics Driver: Unknown hardware 
%   Default Encoding    : windows-1252
%   Deployed            : false
%   Graphics card 1     : Intel Corporation ( 0x8086 ) Intel(R) UHD Graphics 620 Version 22.20.16.4836 (2017-10-17)
%   Host Name           : Or-ZenBook
%   MATLAB Architecture : win64
%   MATLAB Entitlement ID: 4425868
%   MATLAB Root         : C:\Program Files\MATLAB\R2017b
%   MATLAB Version      : 9.3.0.713579 (R2017b)
%   OpenGL              : hardware
%   Operating System    : Microsoft Windows 10 Home
%   Processor ID        : x86 Family 6 Model 142 Stepping 10, GenuineIntel
%   Virtual Machine     : Java 1.8.0_121-b13 with Oracle Corporation Java HotSpot(TM) 64-Bit Server VM mixed mode
%   Window System       : Version 10.0 (Build 17763)
% 
% Fault Count: 1
% 
% 
% Abnormal termination:
% Access violation
% 
% Register State (from fault):
%   RAX = ffffffff80000001  RBX = 0000000000000000
%   RCX = 000000007ffe0380  RDX = 0000000000000000
%   RSP = 00000000043f9e40  RBP = 0000000000000002
%   RSI = 00000000b85ca540  RDI = 00000000b836c014
%  
%    R8 = 0000000000281050   R9 = 0000000000007fb4
%   R10 = 000000000001fed0  R11 = 00000000b85ed060
%   R12 = 0000000000000002  R13 = 000000000001fed1
%   R14 = 000000000001fed1  R15 = 00000000b836c010
%  
%   RIP = 00007ffdd9711c2c  EFL = 00010206
%  
%    CS = 0033   FS = 0053   GS = 002b
% 
% Stack Trace (from fault):
% [  0] 0x00007ffdd9711c2c C:\Users\ornac\Documents\MATLAB\advanced_machine_learning\dynamic_models\mi\estpab.mexw64+00007212 mexFunction+00001180
% [  1] 0x00000000fc60234a                               bin\win64\libmex.dll+00140106 mexRunMexFile+00000314
% [  2] 0x00000000fc600d22                               bin\win64\libmex.dll+00134434 mexFeature_mexver+00002146
% [  3] 0x00000000fc5ffab7                               bin\win64\libmex.dll+00129719 mexUnlock+00028455
% [  4] 0x000000001556ca93                     bin\win64\pgo\m_dispatcher.dll+00117395 Mfh_file::dispatch_fh_impl+00000835
% [  5] 0x000000001556c73e                     bin\win64\pgo\m_dispatcher.dll+00116542 Mfh_file::dispatch_fh+00000062
% [  6] 0x000000001555a8d8                     bin\win64\pgo\m_dispatcher.dll+00043224 Mfunction_handle::dispatch+00001032
% [  7] 0x0000000016259899                            bin\win64\pgo\m_lxe.dll+00235673
% [  8] 0x000000001625b3a6                            bin\win64\pgo\m_lxe.dll+00242598
% [  9] 0x000000001625bfb3                            bin\win64\pgo\m_lxe.dll+00245683
% [ 10] 0x000000001625dff5                            bin\win64\pgo\m_lxe.dll+00253941
% [ 11] 0x000000001625d44f                            bin\win64\pgo\m_lxe.dll+00250959
% [ 12] 0x000000001625d822                            bin\win64\pgo\m_lxe.dll+00251938
% [ 13] 0x000000001632331b                            bin\win64\pgo\m_lxe.dll+01061659 boost::serialization::singleton<boost::archive::detail::pointer_oserializer<boost::archive::binaryTerm_oarchive,MathWorks::lxe::MatlabIrTree> >::get_instance+00604503
% [ 14] 0x000000001632ad46                            bin\win64\pgo\m_lxe.dll+01092934 boost::serialization::singleton<boost::archive::detail::pointer_oserializer<boost::archive::binaryTerm_oarchive,MathWorks::lxe::MatlabIrTree> >::get_instance+00635778
% [ 15] 0x000000001632a570                            bin\win64\pgo\m_lxe.dll+01090928 boost::serialization::singleton<boost::archive::detail::pointer_oserializer<boost::archive::binaryTerm_oarchive,MathWorks::lxe::MatlabIrTree> >::get_instance+00633772
% [ 16] 0x000000001624fc91                            bin\win64\pgo\m_lxe.dll+00195729
% [ 17] 0x000000001624f906                            bin\win64\pgo\m_lxe.dll+00194822
% [ 18] 0x000000001624f925                            bin\win64\pgo\m_lxe.dll+00194853
% [ 19] 0x000000001556ca93                     bin\win64\pgo\m_dispatcher.dll+00117395 Mfh_file::dispatch_fh_impl+00000835
% [ 20] 0x000000001556c73e                     bin\win64\pgo\m_dispatcher.dll+00116542 Mfh_file::dispatch_fh+00000062
% [ 21] 0x000000001555a8d8                     bin\win64\pgo\m_dispatcher.dll+00043224 Mfunction_handle::dispatch+00001032
% [ 22] 0x000000001625794e                            bin\win64\pgo\m_lxe.dll+00227662
% [ 23] 0x0000000016254571                            bin\win64\pgo\m_lxe.dll+00214385
% [ 24] 0x000000001625b3a6                            bin\win64\pgo\m_lxe.dll+00242598
% [ 25] 0x000000001625bfb3                            bin\win64\pgo\m_lxe.dll+00245683
% [ 26] 0x000000001625dff5                            bin\win64\pgo\m_lxe.dll+00253941
% [ 27] 0x000000001625d44f                            bin\win64\pgo\m_lxe.dll+00250959
% [ 28] 0x000000001625d822                            bin\win64\pgo\m_lxe.dll+00251938
% [ 29] 0x000000001632331b                            bin\win64\pgo\m_lxe.dll+01061659 boost::serialization::singleton<boost::archive::detail::pointer_oserializer<boost::archive::binaryTerm_oarchive,MathWorks::lxe::MatlabIrTree> >::get_instance+00604503
% [ 30] 0x000000001632ad46                            bin\win64\pgo\m_lxe.dll+01092934 boost::serialization::singleton<boost::archive::detail::pointer_oserializer<boost::archive::binaryTerm_oarchive,MathWorks::lxe::MatlabIrTree> >::get_instance+00635778
% [ 31] 0x000000001632a570                            bin\win64\pgo\m_lxe.dll+01090928 boost::serialization::singleton<boost::archive::detail::pointer_oserializer<boost::archive::binaryTerm_oarchive,MathWorks::lxe::MatlabIrTree> >::get_instance+00633772
% [ 32] 0x00000000162ba4d6                            bin\win64\pgo\m_lxe.dll+00632022 boost::serialization::singleton<boost::archive::detail::pointer_oserializer<boost::archive::binaryTerm_oarchive,MathWorks::lxe::MatlabIrTree> >::get_instance+00174866
% [ 33] 0x00000000162b9ccd                            bin\win64\pgo\m_lxe.dll+00629965 boost::serialization::singleton<boost::archive::detail::pointer_oserializer<boost::archive::binaryTerm_oarchive,MathWorks::lxe::MatlabIrTree> >::get_instance+00172809
% [ 34] 0x00000000162b9be6                            bin\win64\pgo\m_lxe.dll+00629734 boost::serialization::singleton<boost::archive::detail::pointer_oserializer<boost::archive::binaryTerm_oarchive,MathWorks::lxe::MatlabIrTree> >::get_instance+00172578
% [ 35] 0x00000000162b35a5                            bin\win64\pgo\m_lxe.dll+00603557 boost::serialization::singleton<boost::archive::detail::pointer_oserializer<boost::archive::binaryTerm_oarchive,MathWorks::lxe::MatlabIrTree> >::get_instance+00146401
% [ 36] 0x00000000162b3532                            bin\win64\pgo\m_lxe.dll+00603442 boost::serialization::singleton<boost::archive::detail::pointer_oserializer<boost::archive::binaryTerm_oarchive,MathWorks::lxe::MatlabIrTree> >::get_instance+00146286
% [ 37] 0x00000000162b71d5                            bin\win64\pgo\m_lxe.dll+00618965 boost::serialization::singleton<boost::archive::detail::pointer_oserializer<boost::archive::binaryTerm_oarchive,MathWorks::lxe::MatlabIrTree> >::get_instance+00161809
% [ 38] 0x0000000015775b63                    bin\win64\pgo\m_interpreter.dll+00416611 inEvalCmdWithLocalReturn+00000063
% [ 39] 0x00000000fb60de26                          bin\win64\libmwbridge.dll+00122406 mnParser+00001254
% [ 40] 0x000000001538bdb1                                  bin\win64\mcr.dll+00245169 mcr::runtime::setInterpreterThreadSingletonToCurrent+00029793
% [ 41] 0x000000001538ace5                                  bin\win64\mcr.dll+00240869 mcr::runtime::setInterpreterThreadSingletonToCurrent+00025493
% [ 42] 0x000000001538ad53                                  bin\win64\mcr.dll+00240979 mcr::runtime::setInterpreterThreadSingletonToCurrent+00025603
% [ 43] 0x000000001538b6e1                                  bin\win64\mcr.dll+00243425 mcr::runtime::setInterpreterThreadSingletonToCurrent+00028049
% [ 44] 0x00000000fd02cc77                                  bin\win64\iqm.dll+00642167 iqm::UserEvalPlugin::pre+00028951
% [ 45] 0x00000000fd039cfc                                  bin\win64\iqm.dll+00695548 iqm::UserEvalPlugin::pre+00082332
% [ 46] 0x00000000fd02737f                                  bin\win64\iqm.dll+00619391 iqm::UserEvalPlugin::pre+00006175
% [ 47] 0x00000000fd02cc16                                  bin\win64\iqm.dll+00642070 iqm::UserEvalPlugin::pre+00028854
% [ 48] 0x00000000fd027863                                  bin\win64\iqm.dll+00620643 iqm::UserEvalPlugin::pre+00007427
% [ 49] 0x00000000fd03c8b6                                  bin\win64\iqm.dll+00706742 iqm::UserEvalPlugin::pre+00093526
% [ 50] 0x00000000fd0080f7                                  bin\win64\iqm.dll+00491767 iqm::PackagedTaskPlugin::PackagedTaskPlugin+00000759
% [ 51] 0x00000000fd0088bf                                  bin\win64\iqm.dll+00493759 iqm::PackagedTaskPlugin::execute+00000879
% [ 52] 0x00000000fd00817d                                  bin\win64\iqm.dll+00491901 iqm::PackagedTaskPlugin::PackagedTaskPlugin+00000893
% [ 53] 0x00000000fd008708                                  bin\win64\iqm.dll+00493320 iqm::PackagedTaskPlugin::execute+00000440
% [ 54] 0x00000000fcfdbd3a                                  bin\win64\iqm.dll+00310586 iqm::Iqm::setupIqmFcnPtrs+00079802
% [ 55] 0x00000000fcfdbc06                                  bin\win64\iqm.dll+00310278 iqm::Iqm::setupIqmFcnPtrs+00079494
% [ 56] 0x00000000fcfbf5be                                  bin\win64\iqm.dll+00193982 iqm::Iqm::deliver+00004046
% [ 57] 0x00000000fcfc0545                                  bin\win64\iqm.dll+00197957 iqm::Iqm::deliver+00008021
% [ 58] 0x00000001001237c1                        bin\win64\libmwservices.dll+01259457 services::system_events::PpeDispatchHook::dispatchOne+00021505
% [ 59] 0x0000000100128663                        bin\win64\libmwservices.dll+01279587 sysq::addProcessPendingEventsUnitTestHook+00002211
% [ 60] 0x0000000100128850                        bin\win64\libmwservices.dll+01280080 sysq::addProcessPendingEventsUnitTestHook+00002704
% [ 61] 0x0000000100129c26                        bin\win64\libmwservices.dll+01285158 sysq::getCondition+00003462
% [ 62] 0x000000010012ac66                        bin\win64\libmwservices.dll+01289318 svWS_ProcessPendingEvents+00000230
% [ 63] 0x000000001538c244                                  bin\win64\mcr.dll+00246340 mcr::runtime::setInterpreterThreadSingletonToCurrent+00030964
% [ 64] 0x000000001538c964                                  bin\win64\mcr.dll+00248164 mcr::runtime::setInterpreterThreadSingletonToCurrent+00032788
% [ 65] 0x0000000015382762                                  bin\win64\mcr.dll+00206690 mcr_process_events+00008818
% [ 66] 0x00000000152c23c5                             bin\win64\MVMLocal.dll+00271301 mvm_server::inproc::LocalFactory::terminate+00088005
% [ 67] 0x00000000fa957669                                  bin\win64\mvm.dll+01209961 mvm::detail::initLocalMvmHack+00000569
% [ 68] 0x00000000fa957e2b                                  bin\win64\mvm.dll+01211947 mvm::detail::SessionImpl::privateSession+00000555
% [ 69] 0x00000000fa958051                                  bin\win64\mvm.dll+01212497 mvm::detail::SessionImpl::privateSession+00001105
% [ 70] 0x0000000140007833                               bin\win64\MATLAB.exe+00030771
% [ 71] 0x000000014000863f                               bin\win64\MATLAB.exe+00034367
% [ 72] 0x00007ffde79d7974                   C:\WINDOWS\System32\KERNEL32.DLL+00096628 BaseThreadInitThunk+00000020
% [ 73] 0x00007ffdea69a271                      C:\WINDOWS\SYSTEM32\ntdll.dll+00434801 RtlUserThreadStart+00000033
% 
% 
% This error was detected while a MEX-file was running. If the MEX-file
% is not an official MathWorks function, please examine its source code
% for errors. Please consult the External Interfaces Guide for information
% on debugging MEX-files.
% 
% If this problem is reproducible, please submit a Service Request via:
%     http://www.mathworks.com/support/contact_us/
% 
% A technical support engineer might contact you with further information.
% 
% Thank you for your help.** This crash report has been saved to disk as C:\Users\ornac\AppData\Local\Temp\matlab_crash_dump.2256-1 **
% 
% 
% Caught MathWorks::System::FatalException