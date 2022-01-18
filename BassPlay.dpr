program BassPlay;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  bass in 'bass.pas';

const
  FileName = 'Mic_Paroxyzm.mp3';

var
  stream: HSTREAM;
  time: Integer;
  byteLength, bytePos: Int64;

begin
  try
    stream := 0;
    try
      // инициализация bass.dll
      if not BASS_Init(-1, 44100, 0, 0, nil) then
        raise Exception.Create('BASS_Init fail');

      // создаем стри для файла
      stream := BASS_StreamCreateFile(False, PChar(FileName), 0, 0, BASS_UNICODE);
      if stream = 0 then
        raise Exception.Create('BASS_StreamCreateFile fail');

      // выводим инфо
      byteLength := BASS_ChannelGetLength(stream, BASS_POS_BYTE);
		  time := Trunc(BASS_ChannelBytes2Seconds(stream, byteLength));
		  WriteLn(Format('Length: %d:%.2d', [time div 60, time mod 60]));

      // воспроизводим
      if not BASS_ChannelPlay(stream, False) then
        raise Exception.Create('BASS_ChannelPlay fail');

      // ждем окончания воспроизведения
      while BASS_ChannelIsActive(stream) = BASS_ACTIVE_PLAYING do
      begin
        Sleep(500);
        bytePos := BASS_ChannelGetPosition(stream, BASS_POS_BYTE);
        time := Trunc(BASS_ChannelBytes2Seconds(stream, bytePos));
		    WriteLn(Format('Current: %d:%.2d', [time div 60, time mod 60]));
      end;

    finally
      // освобождаем стрим
      BASS_StreamFree(stream);
      // освобождаем bass.dll
      BASS_Free();
    end;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
