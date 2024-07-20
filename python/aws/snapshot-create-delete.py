import boto3

def create_rds_snapshot(db_instance_id, snapshot_id):
    rds = boto3.client('rds')
    response = rds.create_db_snapshot(
        DBInstanceIdentifier=db_instance_id,
        DBSnapshotIdentifier=snapshot_id
    )
    print(f"Creating snapshot {snapshot_id} for {db_instance_id}")

def delete_rds_snapshot(snapshot_id):
    rds = boto3.client('rds')
    response = rds.delete_db_snapshot(
        DBSnapshotIdentifier=snapshot_id
    )
    print(f"Deleting snapshot {snapshot_id}")

if __name__ == "__main__":
    db_instance_id = 'db-instance-id'
    snapshot_id = 'snapshot-id'
    create_rds_snapshot(db_instance_id, snapshot_id)
    # delete_rds_snapshot(snapshot_id)  # Uncomment to delete the snapshot
