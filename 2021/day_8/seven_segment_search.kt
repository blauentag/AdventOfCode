import java.io.File

fun main() {
    val segments = File("input.txt").readLines()
        .map { it.split("|", limit = 2)[1].trim() }
        .map { it.split(" ", limit = 4) }
        .flatten()

    println(
        listOf(
            segments.filter { it.length == 2 }
                .count(),
            segments.filter { it.length == 3 }
                .count(),
            segments.filter { it.length == 4 }
                .count(),
            segments.filter { it.length == 7 }
                .count()
        ).sum()
    )
}