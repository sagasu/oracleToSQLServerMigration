#split test
$sw = new-object System.Diagnostics.Stopwatch
$sw.Start()
$filename = "C:\Users\gmuk\sql\supply\exportSupply.sql"
$rootName = "C:\Users\gmuk\sql\supply\"
$ext = "sql"

$linesperFile = 100000#100k
$filecount = 1
$reader = $null
try{
    $reader = [io.file]::OpenText($filename)
    try{
        "Creating file number $filecount"
        $writer = [io.file]::CreateText("{0}{1}.{2}" -f ($rootName,$filecount.ToString("000"),$ext))
        $filecount++
        $linecount = 0

        while($reader.EndOfStream -ne $true) {
            "Writing to file $linesperFile"
            $writer.WriteLine("use Arc;");
            while($reader.EndOfStream -ne $true){
                $line = $reader.ReadLine();

                $line = $line.replace(",to_date(", ",cast(");
                $line = $line.replace(",'DD-MON-RR')", " as datetime)");

                if($line -ne "commit;"){
                    $writer.WriteLine($line);
                }else{
                    break;
                }

                $linecount++
            }

            if($reader.EndOfStream -ne $true) {
                "Closing file"
                $writer.Dispose();

                "Creating file number $filecount"
                $writer = [io.file]::CreateText("{0}{1}.{2}" -f ($rootName,$filecount.ToString("000"),$ext))
                $filecount++
                $linecount = 0
                
            }
        }
    } finally {
        $writer.Dispose();
    }
} finally {
    $reader.Dispose();
}
$sw.Stop()

Write-Host "Split complete in " $sw.Elapsed.TotalSeconds "seconds"