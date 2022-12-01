#!/usr/bin/env python

from collections import deque
from copy import copy

# https://docs.python.org/3/library/profile.html
import cProfile
import pstats
from pstats import SortKey
import sys


class Node:
    def __init__(self, point, score):
        self.point = tuple(point)
        self.score = int(score)

    def __eq__(self, other):
        return isinstance(other, self.__class__) and self.point == other.point

    def __hash__(self):
        return hash(self.point)

    def __repr__(self):
        return f"{self.point}:{self.score}"

    def __str__(self):
        return f"{self.point}"



class PathFinder:

    def __init__(self, line_list):
        rows = len(line_list)
        cols = len(line_list[0])
        self.nodes = PathFinder.node_list(line_list, rows, cols)
        self.map  = PathFinder.make_map(line_list, rows, cols)
        self.graph = self.construct_graph(self.nodes, self.map)
        
    def construct_graph(self, nodes, init_graph):
        graph = {}
        for node in nodes:
            graph[node] = {}
        
        graph.update(init_graph)
        
        for node, edges in graph.items():
            for adjacent_node, value in edges.items():
                if graph[adjacent_node].get(node, False) == False:
                    graph[adjacent_node][node] = value
                    
        return graph
    
    def get_nodes(self):
        return self.nodes
    
    def get_outgoing_edges(self, node):
        connections = []
        for out_node in self.nodes:
            if self.graph[node].get(out_node, False) != False:
                connections.append(out_node)
        return connections
    
    def value(self, node1, node2):
        return self.graph[node1][node2]

    @staticmethod
    def find(graph, start_node):
        unvisited_nodes = list(graph.get_nodes())
        shortest_path = {}
        previous_nodes = {}

        max_value = sys.maxsize
        for node in unvisited_nodes:
            shortest_path[node] = max_value

        shortest_path[start_node] = 0

        while unvisited_nodes:
            current_min_node = None
            for node in unvisited_nodes:
                if current_min_node == None:
                    current_min_node = node
                elif shortest_path[node] < shortest_path[current_min_node]:
                    current_min_node = node

            neighbors = graph.get_outgoing_edges(current_min_node)
            for neighbor in neighbors:
                tentative_value = shortest_path[current_min_node] + graph.value(current_min_node, neighbor)
                if tentative_value < shortest_path[neighbor]:
                    shortest_path[neighbor] = tentative_value
                    previous_nodes[neighbor] = current_min_node

            unvisited_nodes.remove(current_min_node)

        return previous_nodes, shortest_path


    @staticmethod
    def print_result(previous_nodes, shortest_path, start_node, target_node):
        path = []
        node = target_node
        
        while node != start_node:
            path.append(node)
            node = previous_nodes[node]
    
        path.append(start_node)
        print(shortest_path[target_node])
        print(sum([node.score for node in path[1:]]), len(path))
        print(" -> ".join([str(node) for node in reversed(path)]))

    @staticmethod
    def make_map(line_list, rows, cols):
        map = {}
        for row in range(rows):
            for col in range(cols):
                map[Node([row, col], line_list[row][col])] = {}
        for key in map.keys():
            row = key.point[0]
            col = key.point[1]
            if key.point[0] + 1 < rows:
                map[key][Node([row + 1, col], line_list[row + 1][col])] = int(line_list[row + 1][col])
            if key.point[1] + 1 < cols:
                map[key][Node([row, col + 1], line_list[row][col + 1])] = int(line_list[row][col + 1])
            if key.point[0] - 1 >= 0:
                map[key][Node([row - 1, col], line_list[row - 1][col])] = int(line_list[row - 1][col])
            if key.point[1] - 1 >= 0:
                map[key][Node([row, col - 1], line_list[row][col - 1])] = int(line_list[row][col - 1])
        return map


    @staticmethod
    def node_list(line_list, rows, cols):
        nodes = []
        for row in range(rows):
            for col in range(cols):
                nodes.append(Node([row, col], line_list[row][col]))
        return nodes


def run():
    with open("./input.txt", "r") as fs:
        lines = fs.read().split("\n")

#         lines = """1163751742
# 1381373672
# 2136511328
# 3694931569
# 7463417111
# 1319128137
# 1359912421
# 3125421639
# 1293138521
# 2311944581""".split(
#         "\n"
#     )

    rows = len(lines)
    start_node = Node([0, 0], lines[0][0])
    target_node = Node([rows - 1, rows - 1], lines[rows - 1][rows - 1])
    path_finder = PathFinder(lines)
    previous_nodes, shortest_path = PathFinder.find(path_finder, start_node )

    print(f"path: {shortest_path}\n")

    PathFinder.print_result(previous_nodes, shortest_path, start_node, target_node)


if __name__ == "__main__":
    cProfile.run("run()")
    # run()
