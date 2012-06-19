with GNAT.Sockets;   use GNAT.Sockets;
with Asterisk_AMI_IO;
with Event_Parser; use Event_Parser;
with Protocol; use Protocol;

package Socket is
   procedure start (channel : Stream_Access);
   --  Her starter det enlige socket program.
private
   
   -- The following types are derived from
   -- http://www.voip-info.org/wiki/view/asterisk+manager+events
   
   type Event is 
     --Agent Status Events
     (Agentcallbacklogin,
      Agentcallbacklogoff,
      AgentCalled,
      AgentComplete,
      AgentConnect,
      AgentDump,
      Agentlogin,
      Agentlogoff,
      QueueMemberAdded,
      QueueMemberPaused,
      QueueMemberStatus,
      -- Command Status Events
      Cdr,
      Dial,
      ExtensionStatus,
      Hangup,
      MusicOnHold,
      Join,
      Leave,
      Link,
      MeetmeJoin,
      MeetmeLeave,
      MeetmeStopTalking,
      MeetmeTalking,
      MessageWaiting,
      Newcallerid,
      Newchannel,
      Newexten,
      ParkedCall,
      Rename,
      SetCDRUserField,
      Unlink,
      UnParkedCall,
      -- Log Status Events
      Alarm,
      AlarmClear,
      DNDState,
      LogChannel,
      PeerStatus,
      Registry,
      Reload,
      Shutdown,
      UserEvent,
      -- Unformatted and Undocumented
      Newstate,
      ParkedCallsComplete,
      QueueParams,
      QueueMember,
      QueueStatusEnd,
      Status,
      StatusComplete,
      ZapShowChannels,
      ZapShowChannelsComplete);

   -- Action types
   type Action is ( WaitEvent, -- Wait for an event to occur (Priv: <none>)
		    PlayDTMF,  -- Play DTMF signal on a specific channel. (Priv: call,all)
		    AgentLogoff, -- Sets an agent as no longer logged in (Priv: agent,all)
		    Agents, -- Lists agents and their status (Priv: agent,all)
		    QueueReset, -- Reset queue statistics (Priv: <none>)
		    QueueReload,-- Reload a queue, queues, or any sub-section of a queue or queues (Priv: <none>)
		    QueueRule,-- Queue Rules (Priv: <none>)
		    QueuePenalty,-- Set the penalty for a queue member (Priv: agent,all)
		    QueueLog,-- Adds custom entry in queue_log (Priv: agent,all)
		    QueuePause,-- Makes a queue member temporarily unavailable (Priv: agent,all)
		    QueueRemove,-- Remove interface from queue. (Priv: agent,all)
		    QueueAdd,-- Add interface to queue. (Priv: agent,all)
		    QueueSummary,-- Queue Summary (Priv: <none>)
		    QueueStatus,-- Queue Status (Priv: <none>)
		    Queues,-- Queues (Priv: <none>)
		    SKINNYshowline,-- Show SKINNY line (text format) (Priv: system,reporting,all)
		    SKINNYlines,-- List SKINNY lines (text format) (Priv: system,reporting,all)
		    SKINNYshowdevice,-- Show SKINNY device (text format) (Priv: system,reporting,all)
		    SKINNYdevices,-- List SKINNY devices (text format) (Priv: system,reporting,all)
		    MeetmeList,-- List participants in a conference (Priv: reporting,all)
		    MeetmeUnmute,-- Unmute a Meetme user (Priv: call,all)
		    MeetmeMute,-- Mute a Meetme user (Priv: call,all)
		    IAXregistry,-- Show IAX registrations (Priv: system,reporting,all)
		    IAXnetstats,-- Show IAX Netstats (Priv: system,reporting,all)
		    IAXpeerlist,-- List IAX Peers (Priv: system,reporting,all)
		    IAXpeers,-- List IAX Peers (Priv: system,reporting,all)
		    SIPnotify,-- Send a SIP notify (Priv: system,all)
		    SIPshowregistry,-- Show SIP registrations (text format) (Priv: system,reporting,all)
		    SIPqualifypeer,-- Show SIP peer (text format) (Priv: system,reporting,all)
		    SIPshowpeer,-- Show SIP peer (text format) (Priv: system,reporting,all)
		    SIPpeers,-- List SIP peers (text format) (Priv: system,reporting,all)
		    VoicemailUsersList,-- List All Voicemail User Information (Priv: call,reporting,all)
		    DAHDIRestart,-- Fully Restart DAHDI channels (terminates calls) (Priv: <none>)
		    DAHDIShowChannels,-- Show status DAHDI channels (Priv: <none>)
		    DAHDIDNDoff,-- Toggle DAHDI channel Do Not Disturb status OFF (Priv: <none>)
		    DAHDIDNDon,-- Toggle DAHDI channel Do Not Disturb status ON (Priv: <none>)
		    DAHDIDialOffhoo,--: Dial over DAHDI channel while offhook (Priv: <none>)
		    DAHDIHangup,-- Hangup DAHDI Channel (Priv: <none>)
		    DAHDITransfer,-- Transfer DAHDI Channel (Priv: <none>)
		    AGI,-- Add an AGI command to execute by Async AGI (Priv: agi,all)
		    UnpauseMonitor,-- Unpause monitoring of a channel (Priv: call,all)
		    PauseMonitor,-- Pause monitoring of a channel (Priv: call,all)
		    ChangeMonitor,-- Change monitoring filename of a channel (Priv: call,all)
		    StopMonitor,-- Stop monitoring a channel (Priv: call,all)
		    Monitor,-- Monitor a channel (Priv: call,all)
		    JabberSend,-- Sends a message to a Jabber Client (Priv: system,all)
		    DBDelTree,-- Delete DB Tree (Priv: system,all)
		    DBDel,-- Delete DB Entry (Priv: system,all)
		    DBPut,-- Put DB Entry (Priv: system,all)
		    DBGet,-- Get DB Entry (Priv: system,reporting,all)
		    Bridge,-- Bridge two channels already in the PBX (Priv: call,all)
		    Park,-- Park a channel (Priv: call,all)
		    ParkedCalls,-- List parked calls (Priv: <none>)
		    ShowDialPlann,-- List dialplan (Priv: config,reporting,all)
		    ModuleCheck,-- Check if module is loaded (Priv: system,all)
		    ModuleLoad,-- Module management (Priv: system,all)
		    CoreShowChannels,-- List currently active channels (Priv: system,reporting,all)
		    Reload,-- Send a reload event (Priv: system,config,all)
		    CoreStatus,-- Show PBX core status variables (Priv: system,reporting,all)
		    CoreSettings,-- Show PBX core settings (version etc) (Priv: system,reporting,all)
		    UserEvent,-- Send an arbitrary event (Priv: user,all)
		    UpdateConfig,-- Update basic configuration (Priv: config,all)
		    SendText,-- Send text message to channel (Priv: call,all)
		    ListCommands,-- List available manager commands (Priv: <none>)
		    MailboxCount,-- Check Mailbox Message Count (Priv: call,reporting,all)
		    MailboxStatus,-- Check Mailbox (Priv: call,reporting,all)
		    AbsoluteTimeout,-- Set Absolute Timeout (Priv: system,call,all)
		    ExtensionState,-- Check Extension Status (Priv: call,reporting,all)
		    Command,-- Execute Asterisk CLI Command (Priv: command,all)
		    Originate,-- Originate Call (Priv: originate,all)
		    Atxfer,-- Attended transfer (Priv: call,all)
		    Redirect,-- Redirect (transfer) a call (Priv: call,all)
		    ListCategories,-- List categories in configuration file (Priv: config,all)
		    CreateConfig,-- Creates an empty file in the configuration directory (Priv: config,all)
		    Status,-- Lists channel status (Priv: system,call,reporting,all)
		    GetConfigJSON,-- Retrieve configuration (JSON format) (Priv: system,config,all)
		    GetConfig,-- Retrieve configuration (Priv: system,config,all)
		    Getvar,-- Gets a Channel Variable (Priv: call,reporting,all)
		    Setvar,-- Set Channel Variable (Priv: call,all)
		    Ping,-- Keepalive command (Priv: <none>)
		    Hangup,-- Hangup Channel (Priv: system,call,all)
		    Challenge,-- Generate Challenge for MD5 Auth (Priv: <none>)
		    Login,-- Login Manager (Priv: <none>)
		    Logoff,-- Logoff Manager (Priv: <none>)
		    Events, -- Control Event Flow (Priv: <none>)
		    None); -- Internal;
   
   -- Basic signature of our callback routine for responses
   type Response_Callback_Type is access procedure (Event:String);
   
   type Callback_Type is access procedure (Event_List: Event_List_Type);
   
   -- Callback table for actions
   type Action_Callback_Routine_Table is array(Action) of Callback_Type;
   
   -- Callback table for log events
   type Event_Callback_Routine_Table is array(Event) of Callback_Type;
   
   type Asterisk_AMI_Type is 
      record
	 Greeting  : access String := null;
	 Logged_In : Boolean := false;
	 Channel   : Stream_Access;
      end record;
   
   -- Callbacks
   procedure Login_Callback(Event_List : in Event_List_Type);
   procedure Dial_Callback(Event_List : in Event_List_Type);
   procedure PeerStatus_Callback(Event_List : in Event_List_Type);

   
end Socket;
