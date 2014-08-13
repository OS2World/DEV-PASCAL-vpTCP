program Telnet;
uses Use32,Sockets,Crt,Strings;

{$PMTYPE VIO}

type
  TFlags	=(Connected,TType,Binary,Echo);
const
  Term		:PChar	='nvt';
  Yes		:PChar	='[yes]';
var
  Port		:UShort;
  Sock		:TSocket;
  Command	:Array[1..64] of Char;
  CommandLen,s	:Integer;
  Local,Remote	:set of TFlags;
  Server	:TSockAddr_in;
  st		:String;

procedure SetOpt(const opt:TFlags);inline;
begin
  case Command[2] of
    #254   :begin
      Local:=Local-[opt];
      Command[2]:=#252;
      Sock_Write(Sock,Command,CommandLen,s);
    end;
    #253   :begin
      Local:=Local+[opt];
      Command[2]:=#251;
      Sock_Write(Sock,Command,CommandLen,s);
    end;
    #252   :Remote:=Remote-[opt];
    #251   :Remote:=Remote+[opt];
  end;
end;

procedure UnknownOpt;inline;
begin
  case Command[2] of
    #254  :begin
      Command[2]:=#252;
      Sock_Write(Sock,Command,CommandLen,s);
    end;
    #253  :begin
      Command[2]:=#251;
      Sock_Write(Sock,Command,CommandLen,s);
    end;
  end;
end;

Procedure SetTermType;
begin
  Case Command[4] of
    #1 :begin
      Command[4]:=#0;
      Sock_Write(Sock,Command,4,s);
      Sock_Write(Sock,Term^,StrLen(Term),s);
      Sock_Write(Sock,Command[CommandLen+1],2,s);
    end;
  end;
end;

Procedure UnknownType;
begin
  Case Command[4] of
    #1 :begin
      Command[4]:=#0;
      Sock_Write(Sock,Command,CommandLen+2,s);
    end;
  end;
end;

Procedure Execute;
var
  c		:Integer;
begin
  if CommandLen=1 then exit;
  case Command[2] of
    #254,#253,#252,#251:if CommandLen=3 then begin
      case Command[3] of
	#0  :SetOpt(Binary);
	#1  :SetOpt(Echo);
	#24 :SetOpt(TType);
	else UnknownOpt;
      end;
      CommandLen:=0;
    end;
    #248	:clreol;
    #247	:write(' '#8);
    #246	:Sock_Write(Sock,Yes^,StrLen(Yes),s);
    #255	:begin
      Write(#255);
      CommandLen:=0;
    end;
    #250	:if CommandLen>3 then begin
      for c:=2 to CommandLen do begin
	if (Command[c-1]=#255)and(Command[c]=#240) then begin
	  dec(CommandLen,2);
	  case Command[3] of
	    #24 :SetTermType;
	    else UnknownType;
	  end;
	  CommandLen:=0;
	  break;
	end;
      end;
    end;
    else if CommandLen=2 then CommandLen:=0;
  end;
end;

procedure ReadData;
var
  buf		:Array[1..512] of Char;
  Len,c 	:Integer;
  fd		:TFD_Set;
begin
  FD_Zero(fd);
  FD_Set(Sock,fd);
  Sock_Select(Sock+1,@fd,nil,nil,0);
{  if Sock_Error then halt(1);}
  if not FD_IsSet(Sock,fd) then exit;
  Len:=0;
  Sock_Read(Sock,buf,sizeof(Buf),Len);
  if (SockError=0)and(Len>0)and(Len<=Sizeof(Buf)) then
  for c:=1 to Len do begin
    if CommandLen>0 then begin
      inc(CommandLen);
      Command[CommandLen]:=buf[c];
      Execute;
    end else
    if buf[c]=#255 then begin
      CommandLen:=1;
      Command[CommandLen]:=buf[c];
    end else
    if buf[c]<>#0 then Write(buf[c]);
  end;
end;


Procedure SendChar(ch:char);
var
  buf		:array[0..1] of char;
begin
  buf[0]:=ch;
  case buf[0] of
    #13   :begin
      buf[1]:=#10;
      Sock_Write(Sock,buf,2,s);
      if Echo in Local then writeln;
    end;
    else begin
      Sock_Write(Sock,buf,1,s);
      if Echo in Local then Write(buf[0]);
    end;
  end;
end;

Procedure Open;
var
  Service		:TServEnt;
  Host			:THostEnt;
begin
  Sock_Init;
  if Sock_Error then halt;

  Sock:=Sock_New(AF_INET,SOCK_STREAM,0);
  if Sock_Error then halt(1);

  {if soSetSockOpt(Sock,SOL_SOCKET,SO_RCVTIMEO,s,SizeOf(s))<0 then begin
    halt(1);
  end;}
  if not GetServiceByName(Service,'telnet','tcp') then halt(2);

  if not GetHostByName(Host,'suma3.rdg.ac.uk') then halt(3);

  Server.sin_family	 := AF_INET;
  Server.sin_port	 := Service.s_port;
  Server.sin_addr	 := Host.h_addr_list[0];

  Writeln('Connecting to ',Host.h_name,' (',inet_ntoa(Host.h_addr_list[0]),')');
  Writeln('Using service ',Service.s_name,', protocol ',Service.s_proto);

  Sock_Connect(Sock,TSockAddr(Server)); 	    (* Bind the socket to the port *)
  if Sock_Error then halt(4);
  Writeln('Connection established.');
  s:=1;
end;

begin
  TextMode(co80);
  CommandLen:=0;Local:=[Echo];Remote:=[];
  Open;
  repeat
    ReadData;
    if Keypressed then SendChar(readkey);
  until SockError<>0;
  Sock_Close(Sock);
end.
