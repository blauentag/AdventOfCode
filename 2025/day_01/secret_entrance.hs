import System.Environment
import System.IO
import Text.Read

parseInstruction :: String -> Int
parseInstruction ('R':xs) = read xs :: Int
parseInstruction ('L':xs) = -(read xs :: Int)
parseInstruction _ = 0

processDial :: [Int] -> Int
processDial instructions = 
    let positions = scanl updatePosition 50 instructions
        zeroCount = length $ filter (== 0) positions
    in zeroCount

updatePosition :: Int -> Int -> Int
updatePosition current distance = 
    let newPosition = (current + distance) `mod` 100
    in newPosition

processDialPart2 :: [Int] -> Int
processDialPart2 instructions = 
    let result = foldl (\(pos, count) dist -> 
            let new_pos = (pos + dist) `mod` 100
                full_rotations = (pos + dist) `div` 100
                new_count = count + abs full_rotations
            in (new_pos, new_count))
            (50, 0) instructions
    in snd result

main :: IO ()
main = do
    args <- getArgs
    case args of
        [filename] -> do
            content <- readFile filename
            let lines' = lines content
            let instructions = map parseInstruction lines'
            let part1 = processDial instructions
            let part2 = processDialPart2 instructions
            putStrLn $ "Part 1: " ++ show part1
            putStrLn $ "Part 2: " ++ show part2
        _ -> putStrLn "Usage: program <filename>"