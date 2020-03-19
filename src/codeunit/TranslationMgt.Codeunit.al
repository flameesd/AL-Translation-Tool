codeunit 78500 "ESD Translation Mgt."
{
    procedure ImportTranslateFile(GetProjectCode: Code[20])
    var
        translateFile: Record "ESD Translate File";
        translateNote: Record "ESD Translate Note";
        translationProject: Record "ESD Translation Project";
        inputFile: File;
        readText: Text;
        sourceText: Text;
        checkTargetNull: Text;
        checkPosStart: Integer;
        checkPosStop: Integer;
        checkLength: Integer;
        checkNotTargetExist: Boolean;
    begin
        translationProject.Get(GetProjectCode);
        inputFile.TEXTMODE := true;
        inputFile.OPEN(translationProject."File Location", TextEncoding::UTF8);
        translateFile.SetRange("Project Code", GetProjectCode);
        if not translateFile.IsEmpty() then
            translateFile.DeleteAll();
        translateNote.SetRange("Project Code", GetProjectCode);
        if not translateNote.IsEmpty() then
            translateNote.DeleteAll();
        While inputFile.READ(readText) <> 0 DO BEGIN
            checkPosStart := StrPos(readText, '<target>');
            if checkNotTargetExist and (checkPosStart = 0) then begin
                checkNotTargetExist := false;
                translateFile.Init();
                translateFile."Project Code" := GetProjectCode;
                translateFile."Line No." := translateFile."Line No." + 1;
                translateFile."Is Not Translate" := true;
                translateFile."Text 1 (1-250)" := '          <target></target>';
                translateFile."Translate Text" := '';
                translateFile."Translate Type" := translateFile."Translate Type"::Target;
                translateFile.Insert();
                Clear(sourceText);
            end;
            translateFile.Init();
            translateFile."Is Not Translate" := false;
            translateFile."Translate Type" := translateFile."Translate Type"::" ";
            translateFile."Translate Text" := '';
            translateFile."Project Code" := GetProjectCode;
            translateFile."Line No." := translateFile."Line No." + 1;
            translateFile."Text 1 (1-250)" := CopyStr(readText, 1, 250);
            translateFile."Text 2 (250-500)" := CopyStr(readText, 251, 250);
            checkPosStart := StrPos(readText, '<source>');
            if checkPosStart <> 0 then begin
                checkPosStop := StrPos(readText, '</source>');
                checkLength := checkPosStop - (checkPosStart + 8);
                sourceText := CopyStr(readText, (checkPosStart + 8), checkLength);
                translateFile."Translate Text" := copystr(CopyStr(readText, (checkPosStart + 8), checkLength), 1, MaxStrLen(translateFile."Translate Text"));
                translateFile."Translate Type" := translateFile."Translate Type"::Source;
                checkNotTargetExist := true;
            end;
            checkPosStart := StrPos(readText, '<target>');
            if checkPosStart <> 0 then begin
                checkNotTargetExist := false;
                checkPosStop := StrPos(readText, '</target>');
                checkLength := checkPosStop - (checkPosStart + 8);
                checkTargetNull := CopyStr(readText, (checkPosStart + 8), checkLength);
                if (checkTargetNull = '') or (checkTargetNull = '[NAB: NOT TRANSLATED]') then
                    translateFile."Is Not Translate" := true
                else
                    CheckInsertDictionary(translationProject."Source Language", translationProject."Target Language", CopyStr(sourceText, 1, MaxStrLen(translateFile."Translate Text")), CopyStr(checkTargetNull, 1, MaxStrLen(translateFile."Translate Text")));
                translateFile."Translate Text" := CopyStr(checkTargetNull, 1, MaxStrLen(translateFile."Translate Text"));
                translateFile."Translate Type" := translateFile."Translate Type"::Target;
                Clear(sourceText);
                Clear(checkTargetNull);
            end;
            translateFile.Insert();
        END;
        inputFile.CLOSE();
        ImporttranslateNotes(GetProjectCode);
    end;

    procedure ImporttranslateNotes(GetProjectCode: Code[20])
    var
        translateFile: Record "ESD Translate File";
        translationProject: Record "ESD Translation Project";
        translateNote: Record "ESD Translate Note";
        finishMsg: Label 'Finish';
    begin
        translationProject.Get(GetProjectCode);
        translateNote.SetRange("Project Code", GetProjectCode);
        if not translateNote.IsEmpty() then
            translateNote.DeleteAll();
        translateFile.SetRange("Project Code", GetProjectCode);
        translateFile.SetRange("Translate Type", translateFile."Translate Type"::Source);
        if translateFile.FindSet() then
            repeat
                if not translateNote.Get(GetProjectCode, translationProject."Source Language", translateFile."Translate Text") then begin
                    translateNote.Init();
                    translateNote."Project Code" := GetProjectCode;
                    translateNote."Source Language" := translationProject."Source Language";
                    translateNote."Source Text" := translateFile."Translate Text";
                    translateNote."Target Language" := translationProject."Target Language";
                    translateNote.Insert();
                end;
            until translateFile.Next() = 0;
        Message(finishMsg);
    end;

    procedure AddSourceText(GetProjectCode: Code[20])
    var
        translateNote: Record "ESD Translate Note";
        finishMsg: Label 'Finish';
    begin
        translateNote.SetRange("Project Code", GetProjectCode);
        if translateNote.FindSet() then
            repeat
                CreateDictionaryFromNote(translateNote);
            until translateNote.Next() = 0;
        Message(finishMsg);
    end;

    procedure CreateDictionaryFromNote(translateNote: Record "ESD Translate Note")
    var
        dictionary: Record "ESD Dictionary";
    begin
        if not dictionary.Get(translateNote."Source Language", translateNote."Target Language", translateNote."Source Text") then begin
            dictionary.Init();
            dictionary."Source Language" := translateNote."Source Language";
            dictionary."Target Language" := translateNote."Target Language";
            dictionary."Source Text" := translateNote."Source Text";
            dictionary.Insert();
        end;
    end;

    procedure UpdateDictionaryFromNote(translateNote: Record "ESD Translate Note")
    var
        dictionary: Record "ESD Dictionary";
    begin
        if not dictionary.Get(translateNote."Source Language", translateNote."Target Language", translateNote."Source Text") then begin
            CreateDictionaryFromNote(translateNote);
            dictionary.Get(translateNote."Source Language", translateNote."Target Language", translateNote."Source Text")
        end;
        dictionary."Target Text" := translateNote."Target Text";
        dictionary.Modify()
    end;

    procedure TranslateAll(GetProjectCode: Code[20])
    var
        translateNote: Record "ESD Translate Note";
        finishMsg: Label 'Fiinish the translation. Please check the';
    begin
        translateNote.SetRange("Project Code", GetProjectCode);
        if translateNote.FindSet(true) then
            repeat
                TransLateTranslateNote(translateNote);
            until translateNote.Next() = 0;
        Message(finishMsg);
    end;

    procedure TranslateLine(GetProjectCode: Code[20]; GetSourceText: Text[250])
    var
        translateNote: Record "ESD Translate Note";
        translationProject: Record "ESD Translation Project";
    begin
        translationProject.Get(GetProjectCode);
        translateNote.Get(GetProjectCode, translationProject."Source Language", GetSourceText);
        TransLateTranslateNote(translateNote);
    end;

    local procedure TransLateTranslateNote(var translateNote: Record "ESD Translate Note")
    var
        dictionary: Record "ESD Dictionary";
        TargetText: Text[250];
    begin
        translateNote."Translated by Web" := false;
        TargetText := '';
        if dictionary.Get(translateNote."Source Language", translateNote."Target Language", translateNote."Source Text") then
            TargetText := dictionary."Target Text";
        if TargetText = '' then begin
            TargetText := TranslateWithGoogle('en-US', 'de-DE', translateNote."Source Text");
            translateNote."Translated by Web" := true;
        end;

        translateNote."Target Text" := TargetText;
        translateNote."Is Translated" := true;

        translateNote.Modify();
        if translateNote."Translated by Web" then
            UpdateDictionaryFromNote(translateNote);

        UpdateTranslateFileEditTarget(translateNote."Project Code", translateNote);
    end;

    local procedure TranslateWithGoogle(SourceLang: Text[10]; TargetLang: Text[10]; SourceText: Text[250]) TargetText: text[250]
    var
        EndPoint: Text;
        EndPointTxt: Label 'https://translate.googleapis.com/translate_a/single?client=gtx&sl=%1&tl=%2&dt=t&q=%3', Comment = '%1=Source Language;%2=Target Language;%3=Source Text';

    begin
        HttpClient.DefaultRequestHeaders().Add('User-Agent', 'Dynamics 365');
        EndPoint := StrSubstNo(EndPointTxt, SourceLang, TargetLang, SourceText);
        if not HttpClient.Get(EndPoint, ResponseMessage) then
            Error('The call to the web service failed.');
        if not ResponseMessage.IsSuccessStatusCode() then
            error('The web service returned an error message:\\' + 'Status code: %1\' + 'Description: %2', ResponseMessage.HttpStatusCode(), ResponseMessage.ReasonPhrase());
        ResponseMessage.Content().ReadAs(TransText);
        TargetText := copystr(GetLines(TransText), 1, MaxStrLen(TargetText));

    end;

    local procedure GetLines(inTxt: Text) outTxt: Text;

    begin
        if copystr(inTxt, 1, 1) <> '[' then
            exit;
        while copystr(inTxt, 1, 1) = '[' do
            inTxt := DelChr(inTxt, '<', '[');
        inTxt := DelChr(inTxt, '<', '"');
        outTxt := CopyStr(inTxt, 1, strpos(inTxt, '"') - 1);
        if StrPos(inTxt, '],[') > 0 then begin
            inTxt := CopyStr(inTxt, StrPos(inTxt, '],[') + 3);
            inTxt := DelChr(inTxt, '<', '"');
            outTxt += CopyStr(inTxt, 1, strpos(inTxt, '"') - 1);
        end;
    end;

    procedure UpdateTranslateFileEditTarget(GetProjectCode: Code[20]; translateNote: Record "ESD Translate Note")
    var
        translateFile: Record "ESD Translate File";
        translateFileEditTargetL: Record "ESD Translate File";
        checkPosStart: Integer;
        getTextL: Text;
    begin
        translateFile.SetRange("Project Code", GetProjectCode);
        translateFile.SetRange("Translate Type", translateFile."Translate Type"::Source);
        translateFile.SetRange("Translate Text", translateNote."Source Text");
        if translateFile.FindSet(true) then
            repeat
                translateFileEditTargetL.Get(GetProjectCode, translateFile."Line No." + 1);
                translateFileEditTargetL."Is Not Translate" := false;
                translateFileEditTargetL."Translate Text" := translateNote."Target Text";
                checkPosStart := StrPos(translateFileEditTargetL."Text 1 (1-250)", '<target>');
                getTextL := CopyStr(translateFileEditTargetL."Text 1 (1-250)", 1, (checkPosStart + 7));
                translateFileEditTargetL."Text 1 (1-250)" := getTextL + translateNote."Target Text" + '</target>';
                translateFileEditTargetL.Modify();
            until translateFile.Next() = 0;
    end;

    procedure ExportTranslateFile(GetProjectCode: Code[20])
    var
        translationProject: Record "ESD Translation Project";
        translateFile: Record "ESD Translate File";
        TranslateSetup: Record "ESD Translate Setup";
        fileMgtL: Codeunit "File Management";
        txtFileL: File;
        clientFilePathL: Text;
        txtCRLFL: Text[2];
        finishMsg: Label 'Finish';
        streamOutL: OutStream;
    begin
        txtCRLFL := '';
        txtCRLFL[1] := 13;
        txtCRLFL[2] := 10;

        TranslateSetup.Get();
        translationProject.Get(GetProjectCode);
        clientFilePathL := translationProject."File Location";
        clientFilePathL := CopyStr(FileMgtL.SaveFileDialog('BC File Browser', clientFilePathL, '*XLF files (*.xlf)|*.xlf|All files (*.*)|*.*'), 1, MaxStrLen(clientFilePathL));

        txtFileL.Create(clientFilePathL, TextEncoding::UTF8);
        txtFileL.CreateOutStream(streamOutL);

        translateFile.SetRange("Project Code", GetProjectCode);
        if translateFile.FindSet() then
            repeat
                StreamOutL.WRITETEXT(translateFile."Text 1 (1-250)");
                StreamOutL.WRITETEXT(translateFile."Text 2 (250-500)");
                StreamOutL.WRITETEXT(txtCRLFL);
            until translateFile.Next() = 0;
        TxtFileL.CLOSE();
        Message(finishMsg);
    end;

    procedure DeleteTranslateData(GetProjectCode: Code[20]; showMessage: boolean)
    var
        translateFile: Record "ESD Translate File";
        translateNote: Record "ESD Translate Note";
        deleteQst: Label 'Are you sure for delete data?';
        finishMsg: Label 'Finish';
    begin
        if GetProjectCode = '' then
            exit;
        if showMessage then
            if not Confirm(deleteQst) then
                Error('');
        translateFile.SetRange("Project Code", GetProjectCode);
        if not translateFile.IsEmpty() then begin
            translateFile.DeleteAll();
            translateNote.SetRange("Project Code", GetProjectCode);
            if not translateNote.IsEmpty() then
                translateNote.DeleteAll();
        end;
        if showMessage then
            Message(finishMsg);
    end;

    procedure ImportTranslateFile()
    var
        language: Record Language;
        fileMgtL: Codeunit "File Management";
        inputFile: File;
        readText: Text;
        fileLocation: Text;
        textTranslateSource: Text[250];
        textTranslateTarget: Text[250];
        textSourceCode: Code[10];
        textTargetCode: Code[10];
        textSourceID: Integer;
        textTargetID: Integer;
        languageCode: Integer;
        checkPosStart: Integer;
        checkPosStop: Integer;
        checkLength: Integer;
        finishMsg: Label 'Finish';
    begin
        fileLocation := copystr(FileMgtL.OpenFileDialog('BC File Browser', '', '*TXT files (*.txt)|*.TXT|All files (*.*)|*.*'), 1, MaxStrLen(fileLocation));
        inputFile.TEXTMODE := true;
        inputFile.OPEN(fileLocation);
        While inputFile.READ(readText) <> 0 DO BEGIN
            checkPosStart := StrPos(readText, '-A');
            if checkPosStart <> 0 then begin
                checkPosStop := StrPos(readText, '-L');
                checkLength := checkPosStop - (checkPosStart + 2);
                Evaluate(languageCode, CopyStr(readText, checkPosStart + 2, checkLength));
                language.SetRange("Windows Language ID", languageCode);
                if language.FindFirst() then begin
                    if (textTargetCode <> '') and (textSourceCode = '') then begin
                        textSourceCode := language.Code;
                        textSourceID := languageCode;
                    end;
                    if (textTargetCode = '') and (textSourceCode = '') then begin
                        textTargetCode := language.Code;
                        textTargetID := languageCode;
                    end;
                    checkPosStart := StrPos(readText, ':');
                    if languageCode = textTargetID then
                        textTranslateTarget := CopyStr(readText, checkPosStart + 1, MaxStrLen(textTranslateTarget))
                    else
                        textTranslateSource := CopyStr(readText, checkPosStart + 1, MaxStrLen(textTranslateSource));
                    if (textTranslateSource <> '') and (textTranslateTarget <> '') then begin
                        CheckInsertDictionary(textSourceCode, textTargetCode, textTranslateSource, textTranslateTarget);
                        Clear(textTranslateSource);
                        Clear(textTranslateTarget);
                    end;
                end;
            end;
        END;
        inputFile.CLOSE();
        Message(finishMsg);
    end;

    procedure CheckInsertDictionary(GetSource: Code[10]; GetTarget: Code[10]; GetSourceTranslate: Text[250]; GetTargetTranslate: Text[250])
    var
        dictionary: Record "ESD Dictionary";
    begin
        if not dictionary.Get(GetSource, GetTarget, GetSourceTranslate) then begin
            dictionary.Init();
            dictionary."Source Language" := GetSource;
            dictionary."Target Language" := GetTarget;
            dictionary."Source Text" := CopyStr(GetSourceTranslate, 1, MaxStrLen(dictionary."Source Text"));
            dictionary."Target Text" := CopyStr(GetTargetTranslate, 1, MaxStrLen(dictionary."Target Text"));
            dictionary.Insert();
        end;
    end;

    var
        HttpClient: HttpClient;
        ResponseMessage: HttpResponseMessage;
        TransText: text;
}