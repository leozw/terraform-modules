resource "aws_elasticache_parameter_group" "this" {
  name   = format("%s-%s-pg", var.redis-name, var.environment)
  family = var.family

  dynamic "parameter" {
    for_each = var.num_node_groups != null ? concat([{ name = "cluster-enabled", value = "yes" }], var.parameter) : var.parameter
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }

  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elasticache_subnet_group" "this" {
  name       = format("%s-%s-subnet-group", var.redis-name, var.environment)
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_replication_group" "redis_replication" {

  replication_group_id       = format("%s-%s", var.redis-name, var.environment)
  description                = format("%s-%s", var.redis-name, var.environment)
  node_type                  = var.redis-instance-type != "" ? var.redis-instance-type : "cache.t2.micro"
  num_cache_clusters         = var.redis-instance-number != null ? var.redis-instance-number : null
  auth_token                 = var.redis-password != "" ? var.redis-password : null
  engine_version             = var.redis-engine-version
  parameter_group_name       = aws_elasticache_parameter_group.this.name
  transit_encryption_enabled = var.tls
  port                       = var.redis-port != "" ? var.redis-port : "6379"
  automatic_failover_enabled = var.automatic-failover-enabled
  maintenance_window         = var.maintenance_window
  snapshot_window            = var.snapshot_window
  snapshot_retention_limit   = var.snapshot_retention_limit
  multi_az_enabled           = var.multi_az_enabled

  num_node_groups         = var.cluster_mode_enabled == true && var.num_node_groups != null ? var.num_node_groups : null
  replicas_per_node_group = var.cluster_mode_enabled == true && var.replicas_per_node_group != null ? var.replicas_per_node_group : null

  apply_immediately = var.apply_immediately

  subnet_group_name  = aws_elasticache_subnet_group.this.name
  security_group_ids = var.security_group_ids

  tags = {
    Name        = format("%s-%s", var.redis-name, var.environment)
    Environment = var.environment
    Platform    = "redis"
    Type        = "service"
  }
}
