class Queue
    def initialize
        @data = []
    end

    def enqueue value
        @data << value
    end

    def dequeue
        @data.shift
    end

    def empty?
      @data == []
    end

    def to_s
        display = []
        @data.each do |value|
            display << value
        end
        display
    end
end

class Node
    attr_reader :value, :adjacent_nodes

    def initialize(value)
        @value = value
        @adjacent_nodes = []
    end

    def add_edge adjacent_node
        @adjacent_nodes << adjacent_node
    end

    def to_s
        "#{@value.inspect}"
    end
end

class Graph
    attr_reader :nodes

    def initialize
        @nodes = {}
    end

    def add_node node
        @nodes[node.value] = node
    end

    def add_edge node1, node2
        @nodes[node1.value].add_edge(@nodes[node2.value])
        @nodes[node2.value].add_edge(@nodes[node1.value])
    end

    def to_s
        "" + @nodes.to_s
    end
end

class Board
    attr_reader :board, :graph

    def initialize
        @board = create_board
        @graph = create_graph(@board)
    end

    def get_neighbours index
        neighbour_indices = [
            [-1, 2], [1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1],
        ]
        neighbours = []
        neighbour_indices.each do |square|
            x = index[0] + square[0]
            y = index[1] + square[1]
            if ((x < 8) && (y < 8)) && (x > 0) && (y > 0)
                neighbours.push([x, y])
            end
        end

        neighbours
    end

    def shortest_path starting_square, ending_square
        starting_node = @graph.nodes[[starting_square[0], starting_square[1]]]
        queue = Queue.new
        queue.enqueue(starting_node)
        distances = {}
        @graph.nodes.keys.each do |key|
            distances[key] = -1
        end

        distances[starting_square] = 0
        prev = {}

        while !queue.empty?
            node = queue.dequeue
            node.adjacent_nodes.each_with_index do |neighbour, index|
                if distances[neighbour.value] == -1
                    distances[neighbour.value] = distances[node.value] + 1
                    prev[neighbour.value] = node.value
                    queue.enqueue(neighbour)
                end
            end
        end

        path = []
        current = ending_square
        while current != starting_square
            path.unshift(current)
            current = prev[current]
        end

        puts "You made it in #{distances[ending_square]} moves!"
        path.each do |move|
            puts move.inspect
        end
    end

    private

    def create_board
        board = []
        8.times do |i|
            row = []
            8.times do |j|
                row << [i, j]
            end
            board << row
        end

        board
    end

    def create_graph board
        graph = Graph.new

        8.times do |i|
            8.times do |j|
                node = Node.new([i, j])
                graph.add_node(node)
            end
        end

        board.each do |row|
            row.each do |square|
                node = graph.nodes[[square[0], square[1]]]
                neighbours = get_neighbours(square)
                neighbour_nodes = []
                neighbours.each do |neighbour|
                    neighbour_node = graph.nodes[[neighbour[0], neighbour[1]]]
                    graph.add_edge(node, neighbour_node)
                end
            end
        end
        graph
    end
end

board = Board.new
