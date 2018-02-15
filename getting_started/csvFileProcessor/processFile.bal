import ballerina.file;
import ballerina.io;

function getFileRecordChannel (string filePath, string permission, string encoding, string rs, string fs) (io:TextRecordChannel) {
    file:File src = {path:filePath};
    io:ByteChannel channel = src.openChannel(permission);
    io:CharacterChannel characterChannel = channel.toCharacterChannel(encoding);
    io:TextRecordChannel textRecordChannel = characterChannel.toTextRecordChannel(rs, fs);
    return textRecordChannel;
}

function process (io:TextRecordChannel srcRecordChannel, io:TextRecordChannel dstRecordChannel) {
    while (srcRecordChannel.hasNextTextRecord()) {
        string[] records = srcRecordChannel.nextTextRecord();
        dstRecordChannel.writeTextRecord(records);
    }
}

function main (string[] args) {
    string srcFileName = "../samples/csvFileProcessor/files/sample.csv";
    string dstFileName = "../samples/csvFileProcessor/files/sampleResponse.txt";
    io:TextRecordChannel srcRecordChannel = getFileRecordChannel(srcFileName, "r", "UTF-8", "\\r?\\n", ",");
    io:TextRecordChannel dstRecordChannel = getFileRecordChannel(dstFileName, "w", "UTF-8", "\n", "|");
    process(srcRecordChannel, dstRecordChannel);
    srcRecordChannel.closeTextRecordChannel();
    dstRecordChannel.closeTextRecordChannel();
}