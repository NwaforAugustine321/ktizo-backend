"""added trackid to song table

Revision ID: 235f82a595c4
Revises: da244280abdc
Create Date: 2022-05-26 11:16:32.177384

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '235f82a595c4'
down_revision = 'da244280abdc'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('Songs', sa.Column('track_id', sa.String(length=255), nullable=True))
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_column('Songs', 'track_id')
    # ### end Alembic commands ###
