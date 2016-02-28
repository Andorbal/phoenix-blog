# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Pxblog.Repo.insert!(%Pxblog.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Pxblog.Repo
alias Pxblog.Role
alias Pxblog.User
import Ecto.Query, only: [from: 2]

find_or_create_role = fn role_name, admin ->
  case Repo.all(from r in Role, where: r.name == ^role_name and r.admin == ^admin) do
    [] ->
      %Role{}
        |> Role.changeset(%{name: role_name, admin: admin})
        |> Repo.insert!
    [role | _tail] ->
      IO.puts "Role: #{role_name} already exists, skipping"
      role
  end
end

find_or_create_user = fn username, email, role ->
  case Repo.all(from u in User, where: u.username == ^username and u.email == ^email) do
    [] ->
      %User{}
        |> User.changeset(%{username: username, email: email,
          password: "test", password_confirmation: "test",
          role_id: role.id})
        |> Repo.insert
    [user | _tail] ->
      IO.puts "User: #{username} already exists, skipping"
      user
  end
end

_user_role = find_or_create_role.("User Role", false)
admin_role = find_or_create_role.("Admin Role", true)
_admin_user = find_or_create_user.("admin", "admin@test.com", admin_role)
