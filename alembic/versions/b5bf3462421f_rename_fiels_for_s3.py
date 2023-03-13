"""“rename_fiels_for_s3”

Revision ID: b5bf3462421f
Revises: bba506e94efd
Create Date: 2023-01-08 21:57:54.045784

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'b5bf3462421f'
down_revision = 'bba506e94efd'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('upload_user_files', sa.Column('s3_file_url', sa.String(length=255), nullable=True))
    op.drop_column('upload_user_files', 'data_file_url')
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('upload_user_files', sa.Column('data_file_url', sa.VARCHAR(length=255), autoincrement=False, nullable=True))
    op.drop_column('upload_user_files', 's3_file_url')
    # ### end Alembic commands ###
