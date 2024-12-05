#!/usr/bin/env python


class ProbeLauncher:
    def __init__(self):
        self.x_range, self.y_range = self.ranges()

    def step(self, x_pos, y_pos, x_vel, y_vel):
        x_pos += x_vel
        y_pos += y_vel
        x_vel -= 1 if x_vel > 0 else 0
        y_vel -= 1
        return [x_pos, y_pos, x_vel, y_vel]

    def on_target(self, x, y):
        return x in range(*self.x_range) and y in range(*self.y_range)

    def in_bounds(self, x, y):
        return x < self.x_range[1] and y >= self.y_range[0]

    def x_options(self):
        return range(self.x_range[1])

    def y_options(self):
        return range(self.y_range[0], abs(self.y_range[0]))

    def max_y(self, initial_y_velocity):
        return (initial_y_velocity * initial_y_velocity + initial_y_velocity) / 2

    def ranges(self):
        with open("./input.txt", "r") as fs:
            return map(
                lambda coords: [int(coords[0]), int(coords[1]) + 1],
                map(
                    lambda s: s.replace("x=", "").replace("y=", "").split(".."),
                    fs.read().split("\n")[0].replace("target area: ", "").split(","),
                ),
            )

    def run(self):
        targets = []
        best_y_velocoity = self.y_range[0]
        for x in self.x_options():
            for y in self.y_options():
                x_pos, y_pos, x_vel, y_vel = 0, 0, x, y
                while self.in_bounds(x_pos, y_pos):
                    x_pos, y_pos, x_vel, y_vel = self.step(x_pos, y_pos, x_vel, y_vel)
                    if self.on_target(x_pos, y_pos):
                        targets.append(tuple([x_pos, y_pos]))
                        best_y_velocoity = max(best_y_velocoity, y)
                        break

        print(int(self.max_y(best_y_velocoity)))
        print()
        print(len(targets))


# target area: x=150..171, y=-129..-70
if __name__ == "__main__":
    launcher = ProbeLauncher()
    launcher.run()
