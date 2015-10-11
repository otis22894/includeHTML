function includeHTML
files = dir;
files = files(~[files.isdir]);
files = {files.name};
files = files(cellfun(@(x) strcmp(x(end-3:end),'html'),files));

for i = 1:length(files)
    parseFile(files{i});
end

end

function parseFile(filename)
    urlname = ['file:///' fullfile(pwd,filename)];
    contents = urlread(urlname);
    includes = strfind(contents,'<!-- #include');
    ends = strfind(contents,'<!-- #end');
    for i = 1:length(includes)
        spaces = strfind(contents(includes(i)+15:end),' ');
        newLines = strfind(contents(1:ends(i)),sprintf('\n'));
        replaceFile = contents(includes(i)+14:spaces(1)+includes(i)+13);
        urlname2 = ['file:///' fullfile(pwd,replaceFile)];
        contents2 = urlread(urlname2);
        contents = [contents(1:strfind(contents(includes(i):end),'>')+includes(i)) ...
            contents2 contents(ends(i)-(ends(i)-newLines(end)):end)];
        includes = strfind(contents,'<!-- #include');
        ends = strfind(contents,'<!-- #end');
        fh = fopen(filename,'w');
        fprintf(fh,contents);
        fclose(fh);
    end
end