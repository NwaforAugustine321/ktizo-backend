"""added withdrawal table

Revision ID: 38e0401ec7fb
Revises: bd94ab96c7a3
Create Date: 2022-06-15 17:34:06.462608

"""
from alembic import op
import sqlalchemy as sa
import sqlalchemy_utils


# revision identifiers, used by Alembic.
revision = '38e0401ec7fb'
down_revision = 'bd94ab96c7a3'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('withdrawal',
    sa.Column('id', sqlalchemy_utils.types.uuid.UUIDType(), nullable=False),
    sa.Column('artist_id', sqlalchemy_utils.types.uuid.UUIDType(), nullable=False),
    sa.Column('amount', sa.String(length=255), nullable=True),
    sa.Column('date', sa.Date(), nullable=True),
    sa.ForeignKeyConstraint(['artist_id'], ['user.id'], ondelete='cascade'),
    sa.PrimaryKeyConstraint('id')
    )
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('withdrawal')
    # ### end Alembic commands ###
