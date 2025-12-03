import java.io.File

fun main() {
  var lines = File("input1-test").readLines()
  var total = 0
  lines.forEach {
    var replaced = it
      .replace("zero", "0")
      .replace("one", "1")
      .replace("two", "2")
      .replace("three", "3")
      .replace("four", "4")
      .replace("five", "5")
      .replace("six", "6")
      .replace("seven", "7")
      .replace("eight", "8")
      .replace("nine", "9")
    println(replaced)
    var first = replaced.first {it.isDigit()}
    var last = replaced.last {it.isDigit()}
    total += "$first$last".toInt()
  }
  println(total)
}

