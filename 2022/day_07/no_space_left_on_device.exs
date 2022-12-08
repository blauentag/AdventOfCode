defmodule NoSpaceLeftOnDevice do
  def instructions do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
  end

  def actions(instruction_steps, state) do
    case instruction_steps do
      ["ls"] -> ls(state)
      ["cd", _] -> cd(Enum.at(instruction_steps, -1), state)
      ["dir", _] -> dir(Enum.at(instruction_steps, -1), state)
      _ -> file(instruction_steps, state)
    end
  end

  def calculate_size(ls_dir) do
    Enum.reduce(
      ls_dir,
      0,
      fn entry, acc ->
        acc +
          case entry do
            {_, value} when is_number(value) -> value
            {_, value} when is_map(value) -> calculate_size(value)
            _ -> 0
          end
      end
    )
  end

  def directory_sizes do
    pwd = [["/"]]
    fs = %{"/" => %{}}

    state =
      instructions()
      |> Enum.reduce(
        {pwd, fs},
        fn instruction, state -> executor(instruction, state) end
      )

    paths =
      Enum.sort_by(
        Enum.uniq(elem(state, 0)),
        &Enum.count(&1),
        :desc
      )

    fs = elem(state, 1)

    Enum.reduce(paths, %{}, fn path, map ->
      Map.merge(
        map,
        %{Enum.map_join(path, & &1) => calculate_size(get_in(fs, path))}
      )
    end)
    |> Map.values()
  end

  def executor(instruction, state) do
    instruction
    |> String.split()
    |> List.delete("$")
    |> then(&actions(&1, state))
  end

  def cd(dir, state) do
    {pwd, fs} = state
    cwd = Enum.at(pwd, -1)

    {
      case dir do
        "/" -> List.insert_at(pwd, -1, ["/"])
        ".." -> List.insert_at(pwd, -1, List.delete_at(cwd, -1))
        _ -> List.insert_at(pwd, -1, List.insert_at(cwd, -1, dir))
      end,
      fs
    }
  end

  def dir(name, state) do
    {pwd, fs} = state
    cwd = Enum.at(pwd, -1)
    dir_list = get_in(fs, cwd)
    mkdir = %{name => %{}}
    dir_list_updated = Map.merge(dir_list, mkdir)
    {pwd, put_in(fs, cwd, dir_list_updated)}
  end

  def file(size_name, state) do
    [size, name] = size_name
    {pwd, fs} = state
    cwd = Enum.at(pwd, -1)
    dir_list = get_in(fs, cwd)
    mkfile = %{name => String.to_integer(size)}
    dir_list_updated = Map.merge(dir_list, mkfile)
    {pwd, put_in(fs, cwd, dir_list_updated)}
  end

  def ls(state) do
    state
  end

  def sum_directory_size_lte(size) do
    directory_sizes()
    |> Enum.filter(&(&1 <= size))
    |> Enum.sum()
  end

  def directory_size_to_delete do
    sizes = directory_sizes()
    used_space = Enum.max(sizes)
    total_space = 70_000_000
    required_space = 30_000_000

    sizes
    |> Enum.filter(&(&1 >= required_space - (total_space - used_space)))
    |> Enum.min()
  end
end

NoSpaceLeftOnDevice.sum_directory_size_lte(100_000) |> IO.inspect(label: "Part 1")
NoSpaceLeftOnDevice.directory_size_to_delete() |> IO.inspect(label: "Part 2")
