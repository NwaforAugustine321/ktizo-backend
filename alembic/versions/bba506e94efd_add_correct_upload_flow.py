"""“add_correct_upload_flow”

Revision ID: bba506e94efd
Revises: 4d8618cc75d4
Create Date: 2023-01-08 21:56:30.201614

"""
import sqlalchemy_utils
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'bba506e94efd'
down_revision = '4d8618cc75d4'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('upload_user_files',
    sa.Column('id', sqlalchemy_utils.types.uuid.UUIDType(), nullable=False),
    sa.Column('user_id', sa.String(length=255), nullable=True),
    sa.Column('data_file_url', sa.String(length=255), nullable=True),
    sa.PrimaryKeyConstraint('id')
    )
    op.add_column('Songs', sa.Column('origin_url', sa.String(length=255), nullable=True))
    op.add_column('Songs', sa.Column('clean_url', sa.String(length=255), nullable=True))
    op.add_column('Songs', sa.Column('instrumental_url', sa.String(length=255), nullable=True))
    op.add_column('Songs', sa.Column('cover_photo', sa.String(length=255), nullable=True))
    op.drop_column('user', 'cover_photo')
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('user', sa.Column('cover_photo', sa.VARCHAR(length=255), autoincrement=False, nullable=True))
    op.drop_column('Songs', 'cover_photo')
    op.drop_column('Songs', 'instrumental_url')
    op.drop_column('Songs', 'clean_url')
    op.drop_column('Songs', 'origin_url')
    op.drop_table('upload_user_files')
    # ### end Alembic commands ###
