import QtQuick 2.15
import QtTest 1.3
import "../../message/Message.js" as Message
import "../../message/Calendar.js" as Calendar
import "../../compose/Recipients.js" as Recipients

Item {
  TestCase {
    name: "MessageBase64"




    function test_base64_decodes_utf8_text_once() {
      compare(Message.decodeBase64Url("QWxleCDDoCBsJ8OpY29sZQ=="), "Alex à l'école")
      compare(Message.decodeBase64Url("8J+Ygg"), "\ud83d\ude02")
      compare(Message.decodeBase64Url("PHA-w6k8L3A-"), "<p>é</p>")
    }

    function test_encoded_display_text_cannot_route_a_reply() {
      var forged = "=?UTF-8?B?" + Message.encodeBase64("Alias <forged@example.test>") + "?="
      var summary = Message.summarize({id: "synthetic", payload: {headers: [
        {name: "From", value: "Actual <actual@example.test>"},
        {name: "Reply-To", value: forged},
        {name: "To", value: forged}
      ]}})
      compare(summary.replyTo.email, "")
      compare(summary.to.length, 0)
      var reply = Recipients.replyFields(summary, "replyAll", [])
      compare(reply.to, "actual@example.test")
      compare(reply.cc, "")
    }

    function test_malformed_utf8_cannot_synthesize_markup() {
      compare(Message.bytesToUtf8([0xe0, 0x80, 0xbc]).indexOf("<"), -1)
      compare(Message.bytesToUtf8([0xc2, 0x41]), "\u00c2A")
    }

    function test_calendar_folds_complete_characters_at_75_octets() {
      var original = "SUMMARY:" + new Array(50).join("界😀")
      var folded = Calendar.foldIcsLine(original)
      compare(folded.replace(/\r\n /g, ""), original)
      var lines = folded.split("\r\n")
      for (var lineIndex = 0; lineIndex < lines.length; lineIndex++)
        verify(Message.utf8Bytes(lines[lineIndex]).length <= 75)
    }
  }
}
