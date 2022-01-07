import Nat "mo:base/Nat";
import Blob "mo:base/Blob";
import Text "mo:base/Text";

actor Counter {

    public type HeaderField = (Text, Text);
    public type HttpRequest = {
        url : Text;
        method : Text;
        body : [Nat8];
        headers : [HeaderField];
    };
    public type Key = Text;
    public type Path = Text; 
    public type ChunkId = Nat;
    public type SetAssetContentArguments = {
        key : Key;
        sha256 : ?[Nat8];
        chunk_ids : [ChunkId];
        content_encoding : Text;
    };
    public type StreamingCallbackHttpResponse = {
        token : ?StreamingCallbackToken;
        body : [Nat8];
    };
    public type StreamingCallbackToken = {
        key : Text;
        sha256 : ?[Nat8];
        index : Nat;
        content_encoding : Text;
    };
    public type StreamingStrategy = {
        #Callback : {
            token : StreamingCallbackToken;
            callback : shared query StreamingCallbackToken -> async StreamingCallbackHttpResponse;
        };
    };
    public type HttpResponse = {
        body : [Nat8];
        headers : [HeaderField];
        streaming_strategy : ?StreamingStrategy;
        status_code : Nat16;
    };
    stable var counter : Nat = 0;

    public shared func init_(x: Nat) : async() {
        counter := x;
    };

    public shared func increase() : async () {
        counter += 1;
    };

    public query func get() : async Nat{
        counter
    };

    public query func http_request(request: HttpRequest) : async HttpResponse {
        
        {
            body = Blob.toArray(Text.encodeUtf8("<html><body><h1> The Counter now is " #Nat.toText(counter) #"</h1></body></html>"));
            headers = [];
            streaming_strategy = null;
            status_code = 200;
        }
    };
}