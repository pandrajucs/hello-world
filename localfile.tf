resource "local_file" "my_file" {
  content = templatefile("details.tpl",
    {
      web01 = aws_instance.k8s_server.0.public_ip

    }
  )
  filename = "inventory"
}
